﻿using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Task.Commands.DeleteTask;
using ERPCubes.Application.Features.Crm.Task.Commands.SaveTask;
using ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskOrder;
using ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskStatus;
using ERPCubes.Application.Features.Crm.Task.Queries.GetTaskList;
using ERPCubes.Application.Features.Crm.Task.Queries.GetTaskTagsList;
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

        public async Task<List<GetCrmTaskListVm>> GetAllTasks(int TenantId, string Id, int CompanyId, int LeadId)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;

                List<GetCrmTaskListVm> obj = await (
                                            from a in _dbContext.CrmTask
                                                .Where(a => a.IsDeleted == 0 && a.TenantId == TenantId && (Id == "-1" || a.CreatedBy == Id) && (LeadId == -1 || a.Id == LeadId) && (CompanyId == -1 || a.Id == CompanyId))
                                            join s in _dbContext.CrmTaskStatus on a.Status equals s.StatusId into all
                                            from ss in all.DefaultIfEmpty()
                                            //let tagId = bb != null ? bb.TagId : (int?)null 
                                            //join c in _dbContext.CrmTags on tagId equals c.TagId into taskGroup
                                            //from cc in taskGroup.DefaultIfEmpty()
                                            select new GetCrmTaskListVm
                                            {
                                                TaskId = a.TaskId,
                                                TaskTitle = a.Title,
                                                DueDate = a.DueDate,
                                                Priority = a.Priority,
                                                Status = (a.DueDate < localDateTime.ToUniversalTime() && a.Status != 1) ? 4: (a.Status==null || a.Status==-1)? 3:a.Status,
                                                Description = a.Description,
                                                TaskOwner = a.TaskOwner,
                                                CreatedBy = a.CreatedBy,
                                                CreatedDate = a.CreatedDate,
                                                TaskType = a.Type,
                                                Order = a.Order,
                                                StatusTitle = (a.DueDate < localDateTime.ToUniversalTime() && a.Status != 1) ? "Overdue" : (a.Status == null || a.Status == -1) ? "Pending" : ss.StatusTitle,
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
                    if (request.CompanyId == -1)
                    {
                        task.IsCompany = -1;
                    }
                    else
                    {
                        task.IsCompany = 1;
                        task.Id = request.CompanyId;
                    }
                    if (request.LeadId == -1)
                    {
                        task.IsLead = -1;
                    }
                    else
                    {
                        task.IsLead = 1;
                        task.Id = request.LeadId;
                    }
                    if(request.LeadId == -1 && request.CompanyId == -1)
                    {
                        task.Id = -1;
                    }
                    await _dbContext.AddAsync(task);
                    await _dbContext.SaveChangesAsync();

                   
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
                        if (request.CompanyId == -1)
                        {
                            task.IsCompany = -1;
                        }
                        else
                        {
                            task.IsCompany = 1;
                            task.Id = request.CompanyId;
                        }
                        if (request.LeadId == -1)
                        {
                            task.IsLead = -1;
                        }
                        else
                        {
                            task.IsLead = 1;
                            task.Id = request.LeadId;
                        }
                        await _dbContext.SaveChangesAsync();

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
                    var taskIdParam = items.TaskId;
                    var orderParam = items.Order;
                    await _dbContext.Database.ExecuteSqlRawAsync("UPDATE \"CrmTask\" SET \"Order\" = {0} WHERE \"TaskId\" = {1}", orderParam, taskIdParam);
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
    }
}

