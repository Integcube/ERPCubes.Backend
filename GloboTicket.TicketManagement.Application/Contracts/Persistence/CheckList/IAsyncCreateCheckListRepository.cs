using ERPCubes.Application.Features.Crm.Checklist.Command.SaveChecklist;
using ERPCubes.Application.Features.Crm.Checklist.Queries.GetChecklists;
using ERPCubes.Application.Features.Crm.Dashboard.Queries.GetDashboards;
using ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskPriority;
using ERPCubes.Application.Features.Notes.Commands.SaveNote;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.CheckList
{
    public interface IAsyncCreateCheckListRepository
    {
        Task<List<GetChecklistVm>> GetAllChecklist(int TenantId, string Id);

        Task SaveChecklist(SaveChecklistCommand request);


    }
}
