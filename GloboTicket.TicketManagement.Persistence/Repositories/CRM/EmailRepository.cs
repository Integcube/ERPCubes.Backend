using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Email.Commands.DeleteEmail;
using ERPCubes.Application.Features.Crm.Email.Commands.SaveEmail;
using ERPCubes.Application.Features.Crm.Email.Queries.GetEmailList;
using ERPCubes.Application.Models.Mail;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class EmailRepository : BaseRepository<CrmEmail>, IAsyncEmailRepository
    {
        public EmailRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task<List<GetEmailVm>> GetAllList(string Id, int TenantId, int LeadId, int CompanyId, int OpportunityId)
        {
            try
            {

                var users = await _dbContextIdentity.Users.Where(a => a.TenantId == TenantId).ToDictionaryAsync(user => user.Id);

                var emails = await _dbContext.CrmEmail
                    .Where(a => a.IsDeleted == 0 &&
                                a.TenantId == TenantId &&
                                (Id == "-1" || a.CreatedBy == Id) &&
                                (LeadId == -1 || (a.Id == LeadId && a.IsLead == 1)) &&
                                (CompanyId == -1 || (a.Id == CompanyId && a.IsCompany == 1)) &&
                                (OpportunityId == -1 || (a.Id == OpportunityId && a.IsOpportunity == 1)))
                    .OrderByDescending(a => a.CreatedDate).Select(email => new GetEmailVm
                    {
                        EmailId = email.EmailId,
                        Subject = email.Subject,
                        Description = email.Description,
                        Reply = email.Reply,
                        CreatedBy = email.CreatedBy,
                        CreatedDate = email.CreatedDate,
                        CreatedbyName = users[email.CreatedBy].FirstName + " " + users[email.CreatedBy].LastName
                    }).ToListAsync();

                return emails;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task DeleteEmail(DeleteEmailCommand emailId)
        {
            try
            {
                var deleteEmail = await (from a in _dbContext.CrmEmail.Where(a => a.EmailId == emailId.EmailId)
                                         select a).FirstOrDefaultAsync();
                if (deleteEmail == null)
                {
                    throw new NotFoundException("emailId", emailId);
                }
                else
                {
                    deleteEmail.IsDeleted = 1;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task SaveEmail(SaveEmailCommand email)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                if (email.EmailId == -1)
                {
                    CrmEmail addEmail = new CrmEmail();
                    addEmail.Subject = email.Subject;
                    addEmail.Description = email.Description;
                    addEmail.CreatedBy = email.Id;
                    addEmail.CreatedDate = localDateTime.ToUniversalTime();
                    addEmail.TenantId = email.TenantId;
                    if (email.CompanyId == -1)
                    {
                        addEmail.IsCompany = -1;
                    }
                    else
                    {
                        addEmail.IsCompany = 1;
                        addEmail.Id = email.CompanyId;
                    }
                    if (email.LeadId == -1)
                    {
                        addEmail.IsLead = -1;
                    }
                    else
                    {
                        addEmail.IsLead = 1;
                        addEmail.Id = email.LeadId;
                    }
                    if (email.OpportunityId == -1)
                    {
                        addEmail.IsOpportunity = -1;
                    }
                    else
                    {
                        addEmail.IsOpportunity = 1;
                        addEmail.Id = email.OpportunityId;
                    }
                    if (email.LeadId == -1 && email.CompanyId == -1 && email.OpportunityId == -1)
                    {
                        addEmail.Id = email.EmailId;
                    }
                    await _dbContext.AddAsync(addEmail);
                    await _dbContext.SaveChangesAsync();

                    CrmUserActivityLog ActivityObj = new CrmUserActivityLog();
                    ActivityObj.UserId = addEmail.CreatedBy;
                    ActivityObj.Detail = addEmail.Subject;
                    ActivityObj.ActivityType = 2;
                    ActivityObj.ActivityStatus = 1;
                    ActivityObj.TenantId = addEmail.TenantId;
                    if (email.CompanyId == -1)
                    {
                        ActivityObj.IsCompany = -1;
                    }
                    else
                    {
                        ActivityObj.IsCompany = 1;
                        ActivityObj.Id = email.CompanyId;
                    }
                    if (email.LeadId == -1)
                    {
                        ActivityObj.IsLead = -1;
                    }
                    else
                    {
                        ActivityObj.IsLead = 1;
                        ActivityObj.Id = email.LeadId;
                    }
                    if (email.OpportunityId == -1)
                    {
                        ActivityObj.IsOpportunity = -1;
                    }
                    else
                    {
                        ActivityObj.IsOpportunity = 1;
                        ActivityObj.Id = email.OpportunityId;
                    }
                    if (email.LeadId == -1 && email.CompanyId == -1 && email.OpportunityId == -1)
                    {
                        ActivityObj.Id = -1;
                    }
                    ActivityObj.CreatedBy = addEmail.CreatedBy;
                    ActivityObj.CreatedDate = addEmail.CreatedDate;
                    await _dbContext.CrmUserActivityLog.AddAsync(ActivityObj);
                    await _dbContext.SaveChangesAsync();
                }
                else
                {
                    var existingEmail = await (from a in _dbContext.CrmEmail.Where(a => a.EmailId == email.EmailId)
                                               select a).FirstOrDefaultAsync();
                    if (existingEmail == null)
                    {
                        throw new NotFoundException(email.Subject, email.EmailId);
                    }
                    else
                    {
                        existingEmail.Subject = email.Subject;
                        existingEmail.Description = email.Description;
                        existingEmail.LastModifiedDate = localDateTime.ToUniversalTime();
                        existingEmail.LastModifiedBy = email.Id;
                        existingEmail.TenantId = email.TenantId;
                        await _dbContext.SaveChangesAsync();
                    }
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
