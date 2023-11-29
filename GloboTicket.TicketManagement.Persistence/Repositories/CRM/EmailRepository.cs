using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Email.Commands.DeleteEmail;
using ERPCubes.Application.Features.Crm.Email.Commands.SaveEmail;
using ERPCubes.Application.Features.Crm.Email.Queries.GetEmailList;
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

        public async Task<List<GetEmailVm>> GetAllList(string Id, int TenantId, int LeadId, int CompanyId)
        {
            try
            {
                List<GetEmailVm> Email = await (from a in _dbContext.CrmEmail.Where(a => a.IsDeleted == 0 && a.TenantId == TenantId && (Id == "-1" || a.CreatedBy == Id) && (LeadId == -1 || a.Id == LeadId) && (CompanyId == -1 || a.Id == CompanyId))
                                                select new GetEmailVm
                                                {
                                                    EmailId = a.EmailId,
                                                    Subject = a.Subject,
                                                    Description = a.Description,
                                                    Reply = a.Reply,
                                                    CreatedBy = a.CreatedBy,
                                                    CreatedDate=a.CreatedDate

                                                }).OrderByDescending(a=>a.CreatedDate).ToListAsync();

                return Email;
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
                var deleteEmail = await(from a in _dbContext.CrmEmail.Where(a => a.EmailId == emailId.EmailId)
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
                    if(email.LeadId==-1 && email.CompanyId==-1)
                    {
                        addEmail.Id = -1;
                    }
                    await _dbContext.AddAsync(addEmail);
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

                        if (email.CompanyId == -1)
                        {
                            existingEmail.IsCompany = -1;
                        }
                        else
                        {
                            existingEmail.IsCompany = 1;
                            existingEmail.Id = email.CompanyId;
                        }
                        if (email.LeadId == -1)
                        {
                            existingEmail.IsLead = -1;
                        }
                        else
                        {
                            existingEmail.IsLead = 1;
                            existingEmail.Id = email.LeadId;
                        }
                        if (email.LeadId == -1 && email.CompanyId == -1)
                        {
                            existingEmail.Id = -1;
                        }
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
