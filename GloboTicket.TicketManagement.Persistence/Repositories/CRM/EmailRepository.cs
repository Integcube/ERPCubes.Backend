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
using System.Runtime.ConstrainedExecution;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class EmailRepository : BaseRepository<CrmEmail>, IAsyncEmailRepository
    {
        public EmailRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task<List<GetEmailVm>> GetAllList(string Id, int TenantId, int ContactTypeId, int ContactId)
        {
            try
            {
                var emails = await (from a in _dbContext.CrmEmail.Where(a => a.IsDeleted == 0
                                    && a.TenantId == TenantId
                                    && (Id == "-1" || a.CreatedBy == Id)
                                    && (a.Id == ContactId)
                                    && (a.ContactTypeId == ContactTypeId))
                                    join user in _dbContext.AppUser on a.CreatedBy equals user.Id into allUsers
                                    from user in allUsers.DefaultIfEmpty()
                                    select new GetEmailVm
                                    {
                                        EmailId = a.EmailId,
                                        Subject = a.Subject,
                                        Description = a.Description,
                                        Reply = a.Reply,
                                        CreatedBy = a.CreatedBy,
                                        CreatedDate = a.CreatedDate,
                                        CreatedbyName = user == null ? "User Not Found" : user.FirstName + " " + user.LastName
                                    })
                 .OrderByDescending(a => a.CreatedDate)
                 .ToListAsync();

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
            using (var transaction = await _dbContext.Database.BeginTransactionAsync())
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
                        addEmail.ContactTypeId = email.ContactTypeId;
                        addEmail.Id = email.ContactId;
                        await _dbContext.AddAsync(addEmail);
                        await _dbContext.SaveChangesAsync();

                        var result = _dbContext.Database.ExecuteSqlRaw(
                                   "CALL public.InsertCrmUserActivityLog({0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8},{9})",
                                      addEmail.CreatedBy, (int)CrmEnum.UserActivityEnum.Email, 1, addEmail.Subject, addEmail.CreatedBy, addEmail.TenantId, addEmail.ContactTypeId, addEmail.EmailId, "Insertion", addEmail.Id);

                        await _dbContext.SaveChangesAsync();
                        await transaction.CommitAsync();

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
                            var result = _dbContext.Database.ExecuteSqlRaw(
                                   "CALL public.InsertCrmUserActivityLog({0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8},{9})",
                                      existingEmail.CreatedBy, (int)CrmEnum.UserActivityEnum.Email, 1, existingEmail.Subject, existingEmail.CreatedBy, existingEmail.TenantId, existingEmail.ContactTypeId, existingEmail.EmailId, "Update", existingEmail.Id);
                            await _dbContext.SaveChangesAsync();
                            await transaction.CommitAsync();

                        }
                    }
                }
                catch (Exception ex)
                {
                    await transaction.RollbackAsync();
                    throw new BadRequestException(ex.Message);

                }
            }
        }
    }
}
