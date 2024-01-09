using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Call.Commands.DeleteCall;
using ERPCubes.Application.Features.Crm.Call.Commands.SaveCall;
using ERPCubes.Application.Features.Crm.Call.Queries.GetCallList;
using ERPCubes.Application.Features.Crm.Call.Queries.GetCallScenariosList;
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
    public class CallRepository : BaseRepository<CrmCall>, IAsyncCallRepository
    {
        public CallRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task<List<GetCallScenariosVm>> ScenariosList()
        {
            try
            {

                List<GetCallScenariosVm> reasons = await _dbContext.GetCallScenariosVm.Where(a => a.IsDeleted == 0).ToListAsync();
                return reasons;

            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task DeleteCall(DeleteCallCommand callId)
        {
            try
            {
                var deleteCall = await (from a in _dbContext.CrmCall.Where(a => a.CallId == callId.CallId)
                                        select a).FirstOrDefaultAsync();
                if (deleteCall == null)
                {
                    throw new NotFoundException("callId", callId);
                }
                else
                {
                    deleteCall.IsDeleted = 1;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetCallVm>> GetAllList(string Id, int TenantId, int LeadId, int CompanyId, int OpportunityId)
        {
            try
            {
                var users = await _dbContextIdentity.Users.Where(u => u.TenantId == TenantId).ToDictionaryAsync(user => user.Id);

                List<GetCallVm> calls = await (
                    from a in _dbContext.CrmCall
                    where a.IsDeleted == 0 &&
                          a.TenantId == TenantId &&
                          (Id == "-1" || a.CreatedBy == Id) &&
                          (LeadId == -1 || (a.Id == LeadId && a.IsLead == 1)) &&
                          (CompanyId == -1 || (a.Id == CompanyId && a.IsCompany == 1)) &&
                          (OpportunityId == -1 || (a.Id == OpportunityId && a.IsOpportunity == 1))
                    join task in _dbContext.CrmTask on a.TaskId equals task.TaskId into all
                    from tasks in all.DefaultIfEmpty()
                    select new GetCallVm
                    {
                        CallId = a.CallId,
                        Subject = a.Subject,
                        Response = a.Response == null ? "" : a.Response,
                        StartTime = a.StartTime,
                        EndTime = a.EndTime,
                        CreatedBy = a.CreatedBy,
                        CreatedDate = a.CreatedDate,
                        CreatedByName = users.ContainsKey(a.CreatedBy) ? users[a.CreatedBy].FirstName + " " + users[a.CreatedBy].LastName : null,
                        ReasonId = a.ReasonId,
                        TaskId = a.TaskId,
                        DueDate = tasks.DueDate,
                        IsTask = -1
                    }).OrderByDescending(a => a.CreatedDate).ToListAsync();

                return calls;

            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task SaveCall(SaveCallCommand call)
        {
            using (var transaction = await _dbContext.Database.BeginTransactionAsync())
            {
                try
                {
                    DateTime localDateTime = DateTime.Now;
                    int TaskId = -1;
                    if (call.TaskId == -1 && call.IsTask == 1)
                    {
                        CrmTask task = new CrmTask();
                        task.Title = call.Subject;
                        task.DueDate = call.DueDate;
                        task.Priority = 1;
                        task.Status = (int)CrmEnum.TaskEnum.Pending;
                        task.TaskOwner = call.Id;
                        task.Description = call.Response;
                        task.CreatedDate = localDateTime.ToUniversalTime();
                        task.CreatedBy = call.Id;
                        task.TenantId = call.TenantId;
                        task.Type = "task";
                        task.IsDeleted = 0;
                        if (call.CompanyId == -1){task.IsCompany = -1;} else { task.IsCompany = 1;task.Id = call.CompanyId;}
                        if (call.LeadId is -1)
                        {
                            task.IsLead = -1;
                        }
                        else
                        {
                            task.IsLead = 1;
                            task.Id = call.LeadId;
                        }
                        if (call.OpportunityId == -1)
                        {
                            task.IsOpportunity = -1;
                        }
                        else
                        {
                            task.IsOpportunity = 1;
                            task.Id = call.OpportunityId;
                        }
                        if (call.LeadId == -1 && call.CompanyId == -1 && call.OpportunityId == -1)
                        {
                            task.Id = -1;
                        }
                        await _dbContext.AddAsync(task);
                        await _dbContext.SaveChangesAsync();
                        TaskId = task.TaskId;

                    }
                    else if (call.TaskId != -1 && call.IsTask == 1)
                    {
                        var task = await (from a in _dbContext.CrmTask.Where(a => a.TaskId == call.TaskId)
                                          select a).FirstOrDefaultAsync();

                        task.DueDate = call.DueDate;
                        await _dbContext.SaveChangesAsync();
                        TaskId = task.TaskId;
                    }
                    else
                    {
                        var result = _dbContext.Database.ExecuteSqlRaw("DELETE FROM \"CrmTask\" WHERE \"TaskId\" = {0}", call.TaskId);
                        await _dbContext.SaveChangesAsync();
                    }


                    if (call.CallId == -1)
                    {
                        CrmCall addCall = new CrmCall();
                        addCall.Subject = call.Subject;
                        addCall.Response = call.Response;
                        addCall.StartTime = call.StartTime.ToUniversalTime();
                        addCall.EndTime = call.EndTime.ToUniversalTime();
                        addCall.CreatedBy = call.Id;
                        addCall.CreatedDate = localDateTime.ToUniversalTime();
                        addCall.TenantId = call.TenantId;
                        addCall.ReasonId = call.ReasonId;
                        addCall.TaskId = TaskId;
                        if (call.CompanyId == -1)
                        {
                            addCall.IsCompany = -1;
                        }
                        else
                        {
                            addCall.IsCompany = 1;
                            addCall.Id = call.CompanyId;
                        }
                        if (call.LeadId == -1)
                        {
                            addCall.IsLead = -1;
                        }
                        else
                        {
                            addCall.IsLead = 1;
                            addCall.Id = call.LeadId;
                        }
                        if (call.OpportunityId == -1)
                        {
                            addCall.IsOpportunity = -1;
                        }
                        else
                        {
                            addCall.IsOpportunity = 1;
                            addCall.Id = call.OpportunityId;
                        }
                        if (call.LeadId == -1 && call.CompanyId == -1 && call.OpportunityId == -1)
                        {
                            addCall.Id = -1;
                        }
                        await _dbContext.AddAsync(addCall);
                        await _dbContext.SaveChangesAsync();

                        CrmCalenderEvents CalenderObj = new CrmCalenderEvents();
                        CalenderObj.UserId = addCall.CreatedBy;
                        CalenderObj.Description = "You have a " + addCall.Subject;
                        CalenderObj.Type = 1;
                        CalenderObj.CreatedBy = addCall.CreatedBy;
                        CalenderObj.CreatedDate = addCall.CreatedDate;
                        CalenderObj.StartTime = addCall.StartTime;
                        CalenderObj.EndTime = addCall.EndTime;
                        CalenderObj.TenantId = addCall.TenantId;

                        if (call.CompanyId == -1)
                        {
                            addCall.IsCompany = -1;
                        }
                        else
                        {
                            addCall.IsCompany = 1;
                            addCall.Id = call.CompanyId;
                        }
                        if (call.LeadId == -1)
                        {
                            addCall.IsLead = -1;
                        }
                        else
                        {
                            addCall.IsLead = 1;
                            addCall.Id = call.LeadId;
                        }
                        if (call.OpportunityId == -1)
                        {
                            addCall.IsOpportunity = -1;
                        }
                        else
                        {
                            addCall.IsOpportunity = 1;
                            addCall.Id = call.OpportunityId;
                        }
                        if (call.LeadId == -1 && call.CompanyId == -1 && call.OpportunityId == -1)
                        {
                            addCall.Id = -1;
                        }
                        CalenderObj.AllDay = false;
                        await _dbContext.CrmCalenderEvents.AddAsync(CalenderObj);
                        await _dbContext.SaveChangesAsync();

                        CrmUserActivityLog ActivityObj = new CrmUserActivityLog();
                        ActivityObj.UserId = addCall.CreatedBy;
                        ActivityObj.Detail = addCall.Subject;
                        ActivityObj.ActivityType = 1;
                        ActivityObj.ActivityStatus = 1;
                        ActivityObj.TenantId = addCall.TenantId;
                        if (call.CompanyId == -1)
                        {
                            ActivityObj.IsCompany = -1;
                        }
                        else
                        {
                            ActivityObj.IsCompany = 1;
                            ActivityObj.Id = call.CompanyId;
                        }
                        if (call.LeadId == -1)
                        {
                            ActivityObj.IsLead = -1;
                        }
                        else
                        {
                            ActivityObj.IsLead = 1;
                            ActivityObj.Id = call.LeadId;
                        }
                        if (call.OpportunityId == -1)
                        {
                            ActivityObj.IsOpportunity = -1;
                        }
                        else
                        {
                            ActivityObj.IsOpportunity = 1;
                            ActivityObj.Id = call.OpportunityId;
                        }
                        if (call.LeadId == -1 && call.CompanyId == -1 && call.OpportunityId == -1)
                        {
                            ActivityObj.Id = -1;
                        }
                        ActivityObj.CreatedBy = addCall.CreatedBy;
                        ActivityObj.CreatedDate = addCall.CreatedDate;
                        await _dbContext.CrmUserActivityLog.AddAsync(ActivityObj);
                        await _dbContext.SaveChangesAsync();


                        await transaction.CommitAsync();
                    }
                    else
                    {
                        var existingCall = await (from a in _dbContext.CrmCall.Where(a => a.CallId == call.CallId)
                                                  select a).FirstAsync();
                        if (existingCall == null)
                        {
                            throw new NotFoundException(call.Subject, call.CallId);
                        }
                        else
                        {
                            existingCall.Subject = call.Subject;
                            existingCall.Response = call.Response;
                            existingCall.StartTime = call.StartTime.ToUniversalTime();
                            existingCall.EndTime = call.EndTime.ToUniversalTime();
                            existingCall.LastModifiedBy = call.Id;
                            existingCall.LastModifiedDate = localDateTime.ToUniversalTime();
                            existingCall.ReasonId = call.ReasonId;
                            existingCall.TaskId = TaskId;
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
