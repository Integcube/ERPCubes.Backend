using ERPCubes.Application.Features.CheckList.ExecuteCheckList.Commands.GetAssignedCheckList;
using ERPCubes.Application.Features.CheckList.ExecuteCheckList.Commands.GetAssignedCheckPoint;
using ERPCubes.Application.Features.Crm.Checklist.Command.SaveChecklist;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.CheckList
{
    public interface IAsyncExecuteCheckListRepository
    {
        Task<List<GetAssignedCheckListVm>> GetAssignedCheckList(GetAssignedCheckListQuery request);
        Task<List<GetAssignedCheckPointVm>> GetAssignedCheckPoint(GetAssignedCheckPointQuery request);
        Task SaveAssignedChecklist(SaveChecklistCommand request);
    }
}
