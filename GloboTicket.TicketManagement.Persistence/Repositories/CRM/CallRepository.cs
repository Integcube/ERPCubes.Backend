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
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using static ERPCubes.Persistence.Repositories.CRM.CrmEnum;

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

        public async Task<List<GetCallVm>> GetAllList(string Id, int TenantId, int ContactTypeId, int ContactId)
        {
            try
            {

                List<GetCallVm> calls = await (from a in _dbContext.CrmCall.Where(a => a.IsDeleted == 0
                                                && a.TenantId == TenantId
                                                && (Id == "-1" || a.CreatedBy == Id)
                                                && (a.Id == ContactId)
                                                && (a.ContactTypeId == ContactTypeId))
                                               join task in _dbContext.CrmTask on a.TaskId equals task.TaskId into all
                                               from tasks in all.DefaultIfEmpty()
                                               join user in _dbContext.AppUser on a.CreatedBy equals user.Id into allUsers
                                               from user in allUsers.DefaultIfEmpty()
                                               select new GetCallVm
                                               {
                                                   CallId = a.CallId,
                                                   Subject = a.Subject,
                                                   Response = a.Response == null ? "" : a.Response,
                                                   StartTime = a.StartTime,
                                                   EndTime = a.EndTime,
                                                   CreatedBy = a.CreatedBy,
                                                   CreatedDate = a.CreatedDate,
                                                   CreatedByName = user == null ? "User Not Found" : user.FirstName + " " + user.LastName,
                                                   ReasonId = a.ReasonId,
                                                   TaskId = a.TaskId,
                                                   DueDate = tasks.DueDate,
                                                   IsTask = -1,
                                                   CallDate= a.CallDate,
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
                        task.TaskTypeId = (int)CrmEnum.UserActivityEnum.Call;
                        task.IsDeleted = 0;
                        task.Id = call.ContactId;
                        task.ContactTypeId = call.ContactTypeId; //For Contact Type exp. lead,company
                        await _dbContext.AddAsync(task);
                        await _dbContext.SaveChangesAsync();


                        CrmCalenderEvents CalenderObj = new CrmCalenderEvents();
                        CalenderObj.UserId = task.CreatedBy;
                        CalenderObj.Description =/* GetNameById(request.Task.TaskTypeId) +*/ task.Title;
                        //CalenderObj.Type = task.TaskTypeId = call.Task.TaskTypeId;
                        CalenderObj.CreatedBy = task.CreatedBy;
                        CalenderObj.CreatedDate = task.CreatedDate.ToUniversalTime();
                        CalenderObj.StartTime = call.DueDate != null ? call.DueDate.Value.ToUniversalTime() : DateTime.Now.ToUniversalTime();
                        CalenderObj.EndTime = (call.DueDate != null ? call.DueDate.Value.ToUniversalTime() : DateTime.Now.ToUniversalTime());
                        CalenderObj.TenantId = task.TenantId;
                        CalenderObj.AllDay = false;
                        CalenderObj.ContactTypeId = call.ContactTypeId;
                        CalenderObj.Id = call.ContactId;
                        CalenderObj.ActivityId = task.TaskId;

                        await _dbContext.CrmCalenderEvents.AddAsync(CalenderObj);
                        await _dbContext.SaveChangesAsync();

                        var result = _dbContext.Database.ExecuteSqlRaw(
                               "CALL public.InsertCrmUserActivityLog({0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8},{9})",
                                  call.Id, (int)CrmEnum.UserActivityEnum.Task, 1, call.Subject, call.Id, call.TenantId, call.ContactTypeId, call.TaskId, "Insertion", call.ContactId);
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
                        addCall.Id = call.ContactId;
                        addCall.ContactTypeId = call.ContactTypeId;//For Contact Type exp. lead,company
                        addCall.CallDate = call.CallDate.ToUniversalTime();
                        await _dbContext.AddAsync(addCall);
                        await _dbContext.SaveChangesAsync();

                        var result = _dbContext.Database.ExecuteSqlRaw(
                               "CALL public.InsertCrmUserActivityLog({0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8},{9})",
                                  addCall.CreatedBy, (int)CrmEnum.UserActivityEnum.Call, 1, call.Subject, addCall.CreatedBy, addCall.TenantId, addCall.ContactTypeId, addCall.CallId, "Insertion", call.ContactId);
                        await _dbContext.SaveChangesAsync();
                        await transaction.CommitAsync();
                    }
                    else
                    {

                        var existingCall = await (from a in _dbContext.CrmCall.Where(a => a.CallId == call.CallId) select a).FirstAsync();
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
                            existingCall.CallDate = call.CallDate.ToUniversalTime();
                            existingCall.TaskId = TaskId;
                            await _dbContext.SaveChangesAsync();

                            var result = _dbContext.Database.ExecuteSqlRaw(
                                   "CALL public.InsertCrmUserActivityLog({0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8},{9})",
                                      call.Id, 1, 1, call.Subject, call.Id, call.TenantId, call.ContactTypeId, call.CallId, "Update", call.ContactId);
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
