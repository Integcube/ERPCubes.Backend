using ERPCubes.Application.Features.Crm.Task.Queries.GetTaskList;
using ERPCubes.Application.Features.Crm.Task.Queries.GetTaskTagsList;
using ERPCubes.Application.Features.Tags.Queries.GetTagsList;
using ERPCubes.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncTaskRepository:IAsyncRepository<CrmTask>
    {
        Task<List<GetCrmTaskListVm>> GetAllTasks(int TenantId, string Id, int CompanyId, int LeadId);
        Task<List<GetTaskTagsListVm>> GetAllTaskTags(int TenantId, string Id, int TaskId);

    }
}
