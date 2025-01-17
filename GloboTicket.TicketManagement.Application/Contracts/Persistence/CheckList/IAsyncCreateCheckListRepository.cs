﻿using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.DeleteAssignCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetExcutedCheckListbyId;
using ERPCubes.Application.Features.CheckList.CreateCheckList.DeleteCreateChecklist;
using ERPCubes.Application.Features.CheckList.CreateCheckList.Queries.GetCheckpoints;
using ERPCubes.Application.Features.CheckList.CreateCheckList.Queries.GetCreateCheckListbyId;
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
        Task<List<GetCheckpointsVm>> GetAllCheckpoint(int TenantId, string Id, int CLId);

        Task SaveChecklist(SaveChecklistCommand request);
        Task Delete(DeleteCreateChecklistCommand request);
        Task<GetCreateCheckListbyIdVm> GetCreateCheckListbyId(GetCreateCheckListbyIdQuery request);


    }
}
