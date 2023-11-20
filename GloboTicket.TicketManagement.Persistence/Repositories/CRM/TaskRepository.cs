using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Task.Queries.GetTaskList;
using ERPCubes.Application.Features.Crm.Task.Queries.GetTaskTagsList;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.Design;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class TaskRepository : BaseRepository<CrmTask>, IAsyncTaskRepository
    {
        public TaskRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity)
            : base(dbContext, dbContextIdentity) { }

        public async Task<List<GetCrmTaskListVm>> GetAllTasks(int TenantId, string Id, int CompanyId, int LeadId)
        {
            try
            {
                List<GetCrmTaskListVm> obj = await (
                                            from a in _dbContext.CrmTask
                                                .Where(a => a.IsDeleted == 0 && a.TenantId == TenantId && (Id == "-1" || a.CreatedBy == Id) && (LeadId == -1 || a.Id == LeadId) && (CompanyId == -1 || a.Id == CompanyId))
                                            join s in _dbContext.CrmTaskStatus on a.Status equals s.StatusId
                                            //let tagId = bb != null ? bb.TagId : (int?)null 
                                            //join c in _dbContext.CrmTags on tagId equals c.TagId into taskGroup
                                            //from cc in taskGroup.DefaultIfEmpty()
                                            select new GetCrmTaskListVm
                                            {
                                                TaskId = a.TaskId,
                                                TaskTitle = a.Title,
                                                DueDate = a.DueDate,
                                                Priority = a.Priority,
                                                Status = a.Status,
                                                Description = a.Description,
                                                TaskOwner = a.TaskOwner,
                                                CreatedBy = a.CreatedBy,
                                                CreatedDate = a.CreatedDate,
                                                TaskType = a.Type,
                                                StatusTitle = s.StatusTitle
                                            }).OrderByDescending(a=>a.CreatedDate).ToListAsync();
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
                from b in _dbContext.CrmTags.Where(a => a.IsDeleted == 0)
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
    }
}


