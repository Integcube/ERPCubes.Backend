﻿using ERPCubes.Application.Features.AppUser.Commands.BulkRestoreUser;
using ERPCubes.Application.Features.AppUser.Commands.DeleteUser;
using ERPCubes.Application.Features.AppUser.Commands.RestoreUser;
using ERPCubes.Application.Features.AppUser.Commands.UpdateUser;
using ERPCubes.Application.Features.AppUser.Queries.GetDeletedUserList;
using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Application.Features.AppUser.Queries.LazyGetUserList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.AssignCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.AssigntToLeadsCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.DeleteAssignCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetExcutedCheckListbyId;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.LazyGetAssignCheckList;
using ERPCubes.Application.Features.CheckList.ChecklistReports.Queries.ExecutedLeadChecklistReport;
using ERPCubes.Application.Features.CheckList.CreateCheckList.DeleteCreateChecklist;
using ERPCubes.Application.Features.CheckList.CreateCheckList.Queries.GetCheckpoints;
using ERPCubes.Application.Features.CheckList.CreateCheckList.Queries.GetCreateCheckListbyId;
using ERPCubes.Application.Features.CheckList.ExecuteCheckList.Commands.GetAssignedCheckList;
using ERPCubes.Application.Features.CheckList.ExecuteCheckList.Commands.GetAssignedCheckPoint;
using ERPCubes.Application.Features.CheckList.ExecuteCheckList.Queries.SetStatus;
using ERPCubes.Application.Features.Crm.Checklist.Command.SaveChecklist;
using ERPCubes.Application.Features.Crm.Checklist.Queries.CheckListReport;
using ERPCubes.Application.Features.Crm.Checklist.Queries.GetChecklists;
using ERPCubes.Application.Features.Crm.Lead.Commands.SetStatus;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetleadPiplineReport;
using ERPCubes.Application.Features.Crm.Product.Commands.BulkRestoreProduct;
using ERPCubes.Application.Features.Crm.Product.Commands.RestoreProduct;
using ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList;
using ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskPriority;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CkCheckListController : ControllerBase
    {
        private readonly IMediator _mediator;
        public CkCheckListController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpPost("lazyall", Name = "LazyGetAssignCheckList")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<LazyGetAssignCheckListVm>> GetAll(LazyGetAssignCheckListQuery req)
        {
            var dto = await _mediator.Send(req);
            return Ok(dto);
        }

        [HttpPost("getExecutionCheckList", Name = "GetExecutionCheckList")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetAssignedCheckListVm>>> ExecutionList(GetAssignedCheckListQuery req)
        {
            var dto = await _mediator.Send(req);
            return Ok(dto);
        }
        [HttpPost("getExecutionCheckPoint", Name = "GetExecutionCheckPoint")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetAssignedCheckPointVm>>> ExecutionPoint(GetAssignedCheckPointQuery req)
        {
            var dto = await _mediator.Send(req);
            return Ok(dto);
        }

        [HttpPost("saveCheckPointStatus", Name = "SaveCheckPointStatus")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetAssignedCheckPointVm>>> SaveCheckPointStatus()
        {
            return Ok();
        }

        [HttpPost("getchecklist", Name = "GetCheckList")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<LazyGetAssignCheckListVm>> GetCheckList(GetCheckListQuery req)
        {
            var dto = await _mediator.Send(req);
            return Ok(dto);
        }

        [HttpPost("getcheckpoint", Name = "GetCheckPoint")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<GetCheckPointVm>> GetCheckPoint(GetCheckPointQuery req)
        {
            var dto = await _mediator.Send(req);
            return Ok(dto);
        }

        [HttpPost("assign", Name = "SaveCheckPoint")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> AssignCheckPoint(AssignCheckPointCommand req)
        {
            var dto = await _mediator.Send(req);
            return Ok(dto);
        }

        [HttpPost("delete", Name = "DeleteAssignCheckPoint")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> DeleteAssignCheckPoint(DeleteAssignCheckPointCommand req)
        {
            var dto = await _mediator.Send(req);
            return Ok(dto);
        }

        [HttpPost("all", Name = "GetAllChecklists")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetChecklistVm>>> GetAllChecklist(GetChecklistQuery getChecklist)
        {
            var dtos = await _mediator.Send(getChecklist);
            return Ok(dtos);
        }
        [HttpPost("save", Name = "SaveChecklists")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task SaveChecklist(SaveChecklistCommand saveChecklist)
        {
            var dtos = await _mediator.Send(saveChecklist);
        }

        [HttpPost("assignTolead", Name = "AssignToLeadCheckPoint")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> AssignToLeadCheckPoint(AssigntToLeadsCheckPointCommand req)
        {
            var dto = await _mediator.Send(req);
            return Ok(dto);
        }
        [HttpPost("getcheckpoints", Name = "GetAllCheckPoint")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<GetCheckpointsVm>> GetAllCheckPoint(GetCheckpointQuery req)
        {
            var dto = await _mediator.Send(req);
            return Ok(dto);
        }
        [HttpPost("setcheckpointstatus", Name = "SetCheckpointStatus")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> SetStatus(SetStatusCommand req)
        {
            var dto = await _mediator.Send(req);
            return Ok(dto);
        }
        [HttpPost("deleteChecklist", Name = "DeleteCreateChecklist")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> DeleteCreateChecklist(DeleteCreateChecklistCommand req)
        {
            var dto = await _mediator.Send(req);
            return Ok(dto);
        }
        //[HttpPost("deleteAssignedChecklist", Name = "DeleteAssignedChecklist")]
        //[ProducesResponseType(StatusCodes.Status200OK)]
        //public async Task<ActionResult> DeleteAssignedChecklist(UnassignToLeadsCheckPointCommand req)
        //{

        //}


        [HttpPost("getchecklistbyId", Name = "GetExcutedCheckListbyId")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<GetExcutedCheckListbyIdVm>> GetExcutedCheckListbyId(GetExcutedCheckListbyIdQuery req)
        {
            var dto = await _mediator.Send(req);
            return Ok(dto);
        }

        [HttpPost("getcreatechecklistbyId", Name = "GetCreateCheckListbyId")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<GetExcutedCheckListbyIdVm>> GetCreateCheckListbyId(GetCreateCheckListbyIdQuery req)
        {
            var dto = await _mediator.Send(req);
            return Ok(dto);
        }

        [HttpPost("checklistReport", Name = "CheckListReport")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> CheckListReport(CheckListReportQuery leadReport)
        {
            var dtos = await _mediator.Send(leadReport);
            return Ok(dtos);
        }
        [HttpPost("executeChecklistReport", Name = "ExecuteCheckListReport")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> ExecuteCheckListReport(ExecutedLeadChecklistReportQuery leadReport)
        {
            var dtos = await _mediator.Send(leadReport);
            return Ok(dtos);
        }

    }
}
