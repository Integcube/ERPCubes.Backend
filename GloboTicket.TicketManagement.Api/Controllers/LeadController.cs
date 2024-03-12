using ERPCubes.Application.Features.Crm.Lead.Commands.BulkAssignLeads;
using ERPCubes.Application.Features.Crm.Lead.Commands.BulkRestoreLeads;
using ERPCubes.Application.Features.Crm.Lead.Commands.BulkSaveLead;
using ERPCubes.Application.Features.Crm.Lead.Commands.ChangeBulkLeadStatus;
using ERPCubes.Application.Features.Crm.Lead.Commands.ChangeLeadStatus;
using ERPCubes.Application.Features.Crm.Lead.Commands.DeleteBulkLeads;
using ERPCubes.Application.Features.Crm.Lead.Commands.DeleteLead;
using ERPCubes.Application.Features.Crm.Lead.Commands.DeleteLeadScoreQuestion;
using ERPCubes.Application.Features.Crm.Lead.Commands.RestoreDeletedLeads;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveCopyQuestion;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLeadScore;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLeadScoreQuestion;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetCalculateleadScore;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetDeletedLeads;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadAttachments;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadByMonth;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountByMonth;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountByOwner;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountSummary;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadList;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadOwnerWiseReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetleadPiplineReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadScoreQuestions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSource;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSourceByCount;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSourceWiseReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadStatus;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLostCountFilter;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLostCountToday;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetNewCountFilter;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetNewLeadCount;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetNewTodayFilter;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetQualifiedCountFilter;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetQualifiedCountToday;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetScoreListQuery;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetStatusWiseLeads;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalCountFilter;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalLeadCount;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalLostCount;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalQualifiedCount;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalWonCount;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetWonCountFilter;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetWonCountToday;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LeadController : ControllerBase
    {
        private readonly IMediator _mediator;
        public LeadController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [Authorize]
        [HttpPost("all", Name = "GetAllLeads")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetLeadVm>>> GetAllLeads(GetLeadListQuery getLeadList)
        {
            var dtos = await _mediator.Send(getLeadList);
            return Ok(dtos);
        }
        [Authorize]
        [HttpPost("allDeleted", Name = "GetDeletedLeads")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetLeadVm>>> GetDeletedLeads(GetDeletedLeadsQuery getDeletedLeadsList)
        {
            var dtos = await _mediator.Send(getDeletedLeadsList);
            return Ok(dtos);
        }



        [Authorize]
        [HttpPost("restore", Name = "RestoreDeletedLeads")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> RestoreDeletedLeads(RestoreDeletedLeadsCommand restoreDeletedLeads)
        {
            var dtos = await _mediator.Send(restoreDeletedLeads);
            return Ok(dtos);
        }
        [Authorize]
        [HttpPost("allStatus", Name = "GetAllLeadStatus")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetLeadVm>>> GetAllLeadStatus(GetLeadStatusListQuery getLeadList)
        {
            var dtos = await _mediator.Send(getLeadList);
            return Ok(dtos);
        }
        [Authorize]
        [HttpPost("allSource", Name = "GetAllLeadSource")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetLeadVm>>> GetAllLeadSource(GetLeadSourceListQuery getLeadList)
        {
            var dtos = await _mediator.Send(getLeadList);
            return Ok(dtos);
        }
        [Authorize]
        [HttpPost("getLeadAttachments", Name = "GetLeadAttachments")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetLeadAttachmentsVm>>> GetLeadAttachments(GetLeadAttachmentsQuery getLeadAttachments)
        {
            var dtos = await _mediator.Send(getLeadAttachments);
            return Ok(dtos);
        }
        [Authorize]
        [HttpPost("delete", Name = "DeleteLead")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> DeleteLead(DeleteLeadCommand leadCommand)
        {
            var dtos = await _mediator.Send(leadCommand);
            return Ok(dtos);
        }
        [HttpPost("bulkSave", Name = "BulkSave")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> BulkSave(SaveBulkLeadCommand leadCommand)
        {
            var dtos = await _mediator.Send(leadCommand);
            return Ok(dtos);
        }
        [Authorize]
        [HttpPost("save", Name = "SaveLead")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> SaveLead(SaveLeadCommand leadCommand)
        {
            var dtos = await _mediator.Send(leadCommand);
            return Ok(dtos);
        }
        [HttpPost("leadReport", Name = "GetLeadReport")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetLeadReport(GetLeadReportQuery leadReport)
        {
            var dtos = await _mediator.Send(leadReport);
            return Ok(dtos);
        }
        [HttpPost("leadByMonth", Name = "GetLeadByMonth")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetLeadByMonth(GetLeadByMonthListQuery leadByMonth)
        {
            var dtos = await _mediator.Send(leadByMonth);
            return Ok(dtos);
        }

        [HttpPost("leadPiplineReport", Name = "GetleadPiplineReport")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetleadPiplineReport(GetleadPiplineReportQuery leadReport)
        {
            var dtos = await _mediator.Send(leadReport);
            return Ok(dtos);
        }

        [HttpPost("leadSourceWiseReport", Name = "GetLeadSourceWiseReport")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetLeadSourceWise(GetLeadSourceWiseQuery leadSourceReport)
        {
            var dtos = await _mediator.Send(leadSourceReport);
            return Ok(dtos);
        }
        [HttpPost("leadOwnerWiseReport", Name = "GetLeadOwnerWiseReport")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetLeadOwnerWise(GetLeadOwnerWiseQuery leadOwnerReport)
        {
            var dtos = await _mediator.Send(leadOwnerReport);
            return Ok(dtos);
        }
        [HttpPost("ChangeLeadStatus", Name = "ChangeLeadStatus")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> ChangeLeadStatus(ChangeLeadStatusCommand obj)
        {
            var dtos = await _mediator.Send(obj);
            return Ok(dtos);
        }

        [HttpPost("getStatusWiseLeads", Name = "GetStatusWiseLeads")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetStatusWiseLeads(GetStatusWiseLeadsQuery obj)
        {
            var dtos = await _mediator.Send(obj);
            return Ok(dtos);
        }


        [HttpPost("getScoreList", Name = "GetScoreList")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetScoreList(GetScoreListQuery obj)
        {
            var dtos = await _mediator.Send(obj);
            return Ok(dtos);
        }

        [HttpPost("saveleadScore", Name = "SaveleadScore")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> SaveleadScore(SaveLeadScoreCommand obj)
        {
            var dtos = await _mediator.Send(obj);
            return Ok(dtos);
        }

        [HttpPost("calculateleadScore", Name = "CalculateleadScore")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> CalculateleadScore(GetCalculateleadScoreQuery obj)
        {
            var dtos = await _mediator.Send(obj);
            return Ok(dtos);
        }
        [HttpPost("restoreBulkLead", Name = "RestoreBulkLeads")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> RestoreBulkLead(RestoreBulkLeadCommand restore)
        {
            await _mediator.Send(restore);
            return Ok(0);
        }

        [HttpPost("getQuestions", Name = "GetLeadScoreQuestions")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetLeadScoreQuestions(GetLeadScoreQuestionsQuery obj)
        {
            var dtos = await _mediator.Send(obj);
            return Ok(dtos);
        }

        [HttpPost("saveQuestion", Name = "SaveLeadScoreQuestion")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> SaveLeadScoreQuestion(SaveLeadScoreQuestionCommand obj)
        {
            var dtos = await _mediator.Send(obj);
            return Ok(dtos);
        }

        [HttpPost("deleteQuestion", Name = "DeleteLeadScoreQuestion")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> DeleteLeadScoreQuestion(DeleteLeadScoreQuestionCommand obj)
        {
            var dtos = await _mediator.Send(obj);
            return Ok(dtos);
        }

        [HttpPost("saveCopyQuestion", Name = "SaveCopyQuestion")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> SaveCopyQuestion(SaveCopyQuestionCommand obj)
        {
            var dtos = await _mediator.Send(obj);
            return Ok(dtos);
        }

        [Authorize]
        [HttpPost("bulkdelete", Name = "Bulkdelete")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> DeleteBulkLeads(DeleteBulkLeadsCommand leadCommand)
        {
            var dtos = await _mediator.Send(leadCommand);
            return Ok(dtos);
        }

        [Authorize]
        [HttpPost("bulkchangestatus", Name = "BulkChangeStatus")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> BulkChangeStatus(ChangeBulkLeadStatusCommand leadCommand)
        {
            var dtos = await _mediator.Send(leadCommand);
            return Ok(dtos);
        }

        [Authorize]
        [HttpPost("bulkassignleads", Name = "BulkAssignLeads")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> BulkAssignLeads(BulkAssignLeadsCommand leadCommand)
        {
            var dtos = await _mediator.Send(leadCommand);
            return Ok(dtos);
        }
        [HttpPost("leadCountByOwner", Name = "GetLeadCountByOwner")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetLeadCountByOwner(GetLeadCountByOwnerQuery lead)
        {
            var dtos = await _mediator.Send(lead);
            return Ok(dtos);
        }
        [HttpPost("leadCountByMonth", Name = "GetLeadCountByMonth")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetLeadCountByMonth(GetLeadCountByMonthQuery lead)
        {
            var dtos = await _mediator.Send(lead);
            return Ok(dtos);
        }
        [HttpPost("leadCountBySource", Name = "GetLeadCountBySource")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetLeadCountBySource(GetLeadSourceByCountQuery lead)
        {
            var dtos = await _mediator.Send(lead);
            return Ok(dtos);
        }
        [HttpPost("leadCountByTotal", Name = "GetLeadCountByTotal")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetLeadCountByTotal(GetTotalLeadCountQuery lead)
        {
            var dtos = await _mediator.Send(lead);
            return Ok(dtos);
        }
        [HttpPost("leadCountByNew", Name = "GetLeadCountByNew")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetLeadCountByNew(GetNewLeadCountQuery lead)
        {
            var dtos = await _mediator.Send(lead);
            return Ok(dtos);
        }
        [HttpPost("leadCountByQualified", Name = "GetLeadCountByQualified")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetQualifiedCount(GetTotalQualifiedCountQuery lead)
        {
            var dtos = await _mediator.Send(lead);
            return Ok(dtos);
        }
        [HttpPost("leadCountByLost", Name = "GetLeadCountByLost")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetLostCount(GetTotalLostCountQuery lead)
        {
            var dtos = await _mediator.Send(lead);
            return Ok(dtos);
        }
        [HttpPost("leadCountByWon", Name = "GetLeadCountByWon")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetWonCount(GetTotalWonCountQuery lead)
        {
            var dtos = await _mediator.Send(lead);
            return Ok(dtos);
        }
        [HttpPost("leadCountSummary", Name = "GetLeadCountBySummary")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetSummaryCount(GetLeadCountSummaryQuery lead)
        {
            var dtos = await _mediator.Send(lead);
            return Ok(dtos);
        }
        [HttpPost("totalCountFilter", Name = "GetTotalCountFilter")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetTotalCountFilter(GetTotalCountFilterQuery lead)
        {
            var dtos = await _mediator.Send(lead);
            return Ok(dtos);
        }
        [HttpPost("newCountFilter", Name = "GetNewCountFilter")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetNewCountFilter(GetNewCountFilterQuery lead)
        {
            var dtos = await _mediator.Send(lead);
            return Ok(dtos);
        }
        [HttpPost("qualifiedCountFilter", Name = "GetQualifiedCountFilter")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetQualifiedCountFilter(GetQualifiedCountFilterQuery lead)
        {
            var dtos = await _mediator.Send(lead);
            return Ok(dtos);
        }
        [HttpPost("lostCountFilter", Name = "GetLostCountFilter")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetLostCountFilter(GetLostCountFilterQuery lead)
        {
            var dtos = await _mediator.Send(lead);
            return Ok(dtos);
        }
        [HttpPost("wonCountFilter", Name = "GetWonCountFilter")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetWonCountFilter(GetWonCountFilterQuery lead)
        {
            var dtos = await _mediator.Send(lead);
            return Ok(dtos);
        }
        [HttpPost("lostTodayFilter", Name = "GetLostCountToday")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetLostCountToday(GetLostCountTodayQuery lead)
        {
            var dtos = await _mediator.Send(lead);
            return Ok(dtos);
        }
        [HttpPost("newTodayFilter", Name = "GetNewCountToday")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetNewCountToday(GetNewTodayFilterQuery lead)
        {
            var dtos = await _mediator.Send(lead);
            return Ok(dtos);
        }
        [HttpPost("qualifiedTodayFilter", Name = "GetQualifiedCountToday")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetQualifiedCountToday(GetQualifiedCountTodayQuery lead)
        {
            var dtos = await _mediator.Send(lead);
            return Ok(dtos);
        }
        [HttpPost("wonTodayFilter", Name = "GetWonCountToday")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetWonCountToday(GetWonCountTodayQuery lead)
        {
            var dtos = await _mediator.Send(lead);
            return Ok(dtos);
        }
    }
}
