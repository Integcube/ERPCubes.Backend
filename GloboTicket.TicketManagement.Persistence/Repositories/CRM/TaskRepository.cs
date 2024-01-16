﻿using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Task.Commands.DeleteTask;
using ERPCubes.Application.Features.Crm.Task.Commands.SaveTask;
using ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskOrder;
using ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskPriority;
using ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskStatus;
using ERPCubes.Application.Features.Crm.Task.Queries.GetTaskList;
using ERPCubes.Application.Features.Crm.Task.Queries.GetTaskTagsList;
using ERPCubes.Application.Models.Mail;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class TaskRepository : BaseRepository<CrmTask>, IAsyncTaskRepository
    {
        public TaskRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity)
            : base(dbContext, dbContextIdentity) { }

        public async Task DeletTask(DeleteTaskCommand request)
        {
            try
            {
                var task = await (from a in _dbContext.CrmTask.Where(a => a.TaskId == request.TaskId)
                                  select a).FirstOrDefaultAsync();
                if (task == null)
                {
                    throw new NotFoundException(request.TaskTitle, request.TaskId);
                }
                else
                {
                    task.IsDeleted = 1;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task<List<GetCrmTaskListVm>> GetAllTasks(int TenantId, string Id, int ContactTypeId, int ContactId)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;

                List<GetCrmTaskListVm> obj = await (from a in _dbContext.CrmTask.Where(a => a.IsDeleted == 0
                                                              && a.TenantId == TenantId
                                                              && (Id == "-1" || a.CreatedBy == Id)
                                                              && (a.Id == ContactId)
                                                              && (a.ContactTypeId == ContactTypeId))
                                                    join s in _dbContext.CrmTaskStatus on a.Status equals s.StatusId into all
                                                    from ss in all.DefaultIfEmpty()

                                                    select new GetCrmTaskListVm
                                                    {
                                                        TaskId = a.TaskId,
                                                        TaskTitle = a.Title,
                                                        DueDate = a.DueDate,
                                                        Priority = a.Priority,
                                                        Status = (a.DueDate < localDateTime.ToUniversalTime() && a.Status != 1) ? 4 : (a.Status == null || a.Status == -1) ? 3 : a.Status,
                                                        Description = a.Description,
                                                        TaskOwner = a.TaskOwner,
                                                        CreatedBy = a.CreatedBy,
                                                        CreatedDate = a.CreatedDate,
                                                        TaskType = a.Type,
                                                        Order = a.Order,
                                                        StatusTitle = (a.DueDate < localDateTime.ToUniversalTime() && a.Status != 1) ? "Overdue" : (a.Status == null || a.Status == -1) ? "Pending" : ss.StatusTitle,
                                                        TasktypeId = a.TaskTypeId
                                                    }).OrderBy(a => a.Order).ToListAsync();
                return obj;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task<List<GetTaskTagsListVm>> GetAllTaskTags(int TenantId, string Id, int TaskId)
        {
            try
            {
                List<GetTaskTagsListVm> obj = await (
                from b in _dbContext.CrmTags.Where(a => a.IsDeleted == 0 && a.TenantId == TenantId)
                join c in _dbContext.CrmTaskTags.Where(a => a.IsDeleted == 0 && a.TaskId == TaskId) on b.TagId equals c.TagId into all
                from cc in all.DefaultIfEmpty()
                select new GetTaskTagsListVm
                {
                    IsSelected = cc.TaskId == null ? false : true,
                    TagId = b.TagId,
                    TagTitle = b.TagTitle,
                }).ToListAsync();
                return obj;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task SaveTask(SaveTaskCommand request)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;

                if (request.Task.TaskId == -1 || request.Task.TaskId == -2)
                {
                    CrmTask task = new CrmTask();
                    task.Title = request.Task.TaskTitle;
                    task.DueDate = request.Task.DueDate;
                    task.Priority = (int)(request.Task.PriorityId != null ? request.Task.PriorityId : -1);
                    task.Status = (int)(request.Task.StatusId != null ? request.Task.StatusId : -1);
                    task.TaskOwner = request.Task.TaskOwner;
                    task.Description = request.Task.Description;
                    task.CreatedDate = localDateTime.ToUniversalTime();
                    task.CreatedBy = request.Id;
                    task.TenantId = request.TenantId;
                    task.Type = request.Type;
                    task.IsDeleted = 0;
                    task.ContactTypeId = request.ContactTypeId;
                    task.Id = request.ContactId;
                    task.TaskTypeId = request.Task.TaskTypeId;
                    await _dbContext.AddAsync(task);
                    await _dbContext.SaveChangesAsync();
                    var result = _dbContext.Database.ExecuteSqlRaw(
                                                   "CALL public.InsertCrmUserActivityLog({0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8},{9})",
                                                      task.CreatedBy, (int)CrmEnum.UserActivityEnum.Task, 1, task.Title, task.CreatedBy, task.TenantId, task.ContactTypeId, task.TaskId, "Insertion", task.Id);


                    List<int> TagIds = new List<int>();
                    if (!string.IsNullOrEmpty(request.Task.Tags))
                        TagIds = (request.Task.Tags.Split(',').Select(Int32.Parse).ToList());
                    foreach (var item in TagIds)
                    {
                        CrmTaskTags tags = new CrmTaskTags();
                        tags.TaskId = task.TaskId;
                        tags.TagId = item;
                        tags.CreatedBy = request.Id;
                        tags.CreatedDate = localDateTime.ToUniversalTime();
                        tags.TenantId = request.TenantId;
                        await _dbContext.AddAsync(tags);
                        await _dbContext.SaveChangesAsync();
                    }

                    CrmCalenderEvents CalenderObj = new CrmCalenderEvents();
                    CalenderObj.UserId = task.CreatedBy;
                    CalenderObj.Description =/* GetNameById(request.Task.TaskTypeId) +*/ task.Title;
                    CalenderObj.Type = task.TaskTypeId = request.Task.TaskTypeId;
                    CalenderObj.CreatedBy = task.CreatedBy;
                    CalenderObj.CreatedDate = task.CreatedDate;
                    CalenderObj.StartTime = request.Task.DueDate ?? DateTime.Now.ToUniversalTime();
                    CalenderObj.EndTime = (request.Task.DueDate ?? DateTime.Now.ToUniversalTime()).AddDays(1);
                    CalenderObj.TenantId = task.TenantId;
                    CalenderObj.AllDay = false;
                    CalenderObj.ContactTypeId = request.ContactTypeId;
                    CalenderObj.Id = request.ContactId;
                    CalenderObj.ActivityId = task.TaskId;

                    await _dbContext.CrmCalenderEvents.AddAsync(CalenderObj);
                    await _dbContext.SaveChangesAsync();
                }
                else
                {
                    var task = await (from a in _dbContext.CrmTask.Where(a => a.TaskId == request.Task.TaskId)
                                      select a).FirstOrDefaultAsync();
                    if (task == null)
                    {
                        throw new NotFoundException(request.Task.TaskTitle, request.Task.TaskId);
                    }
                    else
                    {
                        task.Title = request.Task.TaskTitle;
                        task.DueDate = request.Task.DueDate;
                        task.Priority = (int)(request.Task.PriorityId != null ? request.Task.PriorityId : -1);
                        task.Status = (int)(request.Task.StatusId != null ? request.Task.StatusId : -1);
                        task.TaskOwner = request.Task.TaskOwner;
                        task.Description = request.Task.Description;
                        task.LastModifiedDate = localDateTime.ToUniversalTime();
                        task.LastModifiedBy = request.Id;
                        task.TenantId = request.TenantId;
                        task.ContactTypeId = request.ContactTypeId;
                        task.Id = request.ContactId;
                        task.TaskTypeId = request.Task.TaskTypeId;
                        await _dbContext.SaveChangesAsync();

                        var result = _dbContext.Database.ExecuteSqlRaw(
                                                   "CALL public.InsertCrmUserActivityLog({0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8},{9})",
                                                      task.CreatedBy, (int)CrmEnum.UserActivityEnum.Task, 1, task.Title, task.CreatedBy, task.TenantId, task.ContactTypeId, task.TaskId, "Update", task.Id);

                        CrmTaskTags? taskTags = await (from a in _dbContext.CrmTaskTags.Where(a => a.TaskId == request.Task.TaskId)
                                                       select a).FirstOrDefaultAsync();
                        if (taskTags != null)
                        {
                            _dbContext.CrmTaskTags.RemoveRange(taskTags);
                            _dbContext.SaveChanges();
                        }

                        List<int> TagIds = new List<int>();
                        if (!string.IsNullOrEmpty(request.Task.Tags))
                            TagIds = (request.Task.Tags.Split(',').Select(Int32.Parse).ToList());
                        foreach (var item in TagIds)
                        {
                            CrmTaskTags tags = new CrmTaskTags();
                            tags.TaskId = task.TaskId;
                            tags.TagId = item;
                            tags.CreatedBy = request.Id;
                            tags.CreatedDate = localDateTime.ToUniversalTime();
                            tags.TenantId = request.TenantId;
                            await _dbContext.AddAsync(tags);
                            await _dbContext.SaveChangesAsync();
                        }

                        var CalenderObj = await (from a in _dbContext.CrmCalenderEvents.Where(a => a.TenantId == request.TenantId
                                                 && a.ActivityId == request.Task.TaskId
                                                 && a.ContactTypeId == request.ContactTypeId
                                                 && a.Id == request.ContactId)
                                                 select a).FirstOrDefaultAsync();

                        CalenderObj.Description = /*GetNameById(request.Task.TaskTypeId) + */task.Title;
                        CalenderObj.Type = task.TaskTypeId = request.Task.TaskTypeId;
                        CalenderObj.StartTime = request.Task.DueDate ?? DateTime.Now.ToUniversalTime();
                        CalenderObj.EndTime = (request.Task.DueDate ?? DateTime.Now.ToUniversalTime()).AddDays(1);
                        await _dbContext.SaveChangesAsync();
                    }
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task UpdateTaskOrder(List<UpdateTaskOrderDto> request)
        {
            try
            {
                foreach (var items in request)
                {
                    await _dbContext.Database.ExecuteSqlRawAsync("UPDATE \"CrmTask\" SET \"Order\" = {0} WHERE \"TaskId\" = {1}", items.TaskId, items.Order);
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task UpdateTaskStatus(UpdateTaskStatusCommand request)
        {
            try
            {
                var task = await (from a in _dbContext.CrmTask.Where(a => a.TaskId == request.TaskId)
                                  select a).FirstOrDefaultAsync();
                if (task == null)
                {
                    throw new NotFoundException(request.TaskTitle, request.TaskId);
                }
                else
                {
                    task.Status = request.Status;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task UpdateTaskPriority(UpdateTaskPriorityCommand request)
        {
            try
            {
                var task = await (from a in _dbContext.CrmTask.Where(a => a.TaskId == request.TaskId)
                                  select a).FirstOrDefaultAsync();
                if (task == null)
                {
                    throw new NotFoundException(request.TaskTitle, request.TaskId);
                }
                else
                {
                    task.Priority = request.Priority;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        //public static string GetNameById(int id)
        //{
        //    switch (id)
        //    {
        //        case 1:
        //            return "You have a Call ";
        //        case 2:
        //            return "You have a Email ";
        //        case 3:
        //            return "You have a Meeting ";
        //        case 4:
        //            return "You have a Important Task ";
        //        case 5:
        //            return "You have a Task ";
        //        default:
        //            return "";
        //    }
        //}

    }
}

