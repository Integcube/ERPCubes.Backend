using ERPCubes.Application.Features.Crm.Task.Commands.DeleteTask;
using ERPCubes.Application.Features.Crm.Task.Commands.RestoreBulkTask;
using ERPCubes.Application.Features.Crm.Task.Commands.RestoreTasks;
using ERPCubes.Application.Features.Crm.Task.Commands.SaveTask;
using ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskOrder;
using ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskPriority;
using ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskStatus;
using ERPCubes.Application.Features.Crm.Task.Queries.GetDeletedTasks;
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
        Task<List<GetCrmTaskListVm>> GetAllTasks(int TenantId, string Id, int ContactTypeId, int ContactId);
        Task<List<GetTaskTagsListVm>> GetAllTaskTags(int TenantId, string Id, int TaskId);
        Task DeletTask(DeleteTaskCommand request);
        Task SaveTask(SaveTaskCommand request);
        Task UpdateTaskStatus(UpdateTaskStatusCommand request);
        Task UpdateTaskOrder(List<UpdateTaskOrderDto> request);
        Task UpdateTaskPriority(UpdateTaskPriorityCommand request);
        Task<List<GetDeletedTaskVm>> GetDeletedTask(int TenantId, string Id);
        Task RestoreTask(RestoreTaskCommand task);
        Task RestoreBulkTask(RestoreBulkTaskCommand note);



    }
}
