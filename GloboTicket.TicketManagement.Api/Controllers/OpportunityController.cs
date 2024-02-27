using ERPCubes.Application.Features.Crm.Lead.Commands.ChangeLeadStatus;
using ERPCubes.Application.Features.Crm.Lead.Commands.DeleteLead;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetDeletedLeads;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadAttachments;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadList;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSource;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadStatus;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.ChangeOpportunityStatus;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.DeleteOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.RestoreBulkOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.RestoreOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.SaveOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetDeletedOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunityAttachments;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunityStatus;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportuntiySource;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OpportunityController : ControllerBase
    {
        private readonly IMediator _mediator;
        public OpportunityController(IMediator mediator)
        {
            _mediator = mediator;
        }
        //[Authorize]
        [HttpPost("all", Name = "GetAllOpportunity")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetOpportunityVm>>> GetAllOpportunity(GetOpportunityQuery getOpportunity)
        {
            var dtos = await _mediator.Send(getOpportunity);
            return Ok(dtos);
        }
        //[Authorize]
        [HttpPost("allSource", Name = "GetAllOpportunitySource")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetOpportunitySourceVm>>> GetAllOpportunitySource(GetOpportunitySourceQuery getOpportunitySource)
        {
            var dtos = await _mediator.Send(getOpportunitySource);
            return Ok(dtos);
        }
        //[Authorize]
        [HttpPost("allStatus", Name = "GetAllOpportunityStatus")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetOpportunityStatusVm>>> GetAllOpportunityStatus(GetLeadStatusListQuery getOpportunityStatus)
        {
            var dtos = await _mediator.Send(getOpportunityStatus);
            return Ok(dtos);
        }
        //[Authorize]
        [HttpPost("delete", Name = "DeleteOpportunity")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> DeleteOpportunity(DeleteOpportunityCommand opportunityCommand)
        {
            var dtos = await _mediator.Send(opportunityCommand);
            return Ok(dtos);
        }
        //[Authorize]
        [HttpPost("save", Name = "SaveOpportunity")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> SaveOpportunity(SaveOpportunityCommand opportunityCommand)
        {
            var dtos = await _mediator.Send(opportunityCommand);
            return Ok(dtos);
        }
        //[Authorize]
        [HttpPost("restore", Name = "RestoreOpportunity")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> RestoredOpportunity(RestoreOpportunityCommand opportunityCommand)
        {
            var dtos = await _mediator.Send(opportunityCommand);
            return Ok(dtos);
        }
        //[Authorize]
        [HttpPost("restoreBulk", Name = "RestoreBulkOpportunity")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> RestoreBulkOpportunity(RestoreBulkOpportunityCommand opportunityCommand)
        {
            var dtos = await _mediator.Send(opportunityCommand);
            return Ok(dtos);
        }
        //[Authorize]
        [HttpPost("allDeleted", Name = "GetDeletedOpportunity")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetDeletedOpportunityVm>>> GetDeletedOpportunity(GetDeletedOpportunityQuery opportunityQuery)
        {
            var dtos = await _mediator.Send(opportunityQuery);
            return Ok(dtos);
        }
        //[Authorize]
        [HttpPost("getAttachments", Name = "GetOpportunityAttachments")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetOpportunityAttachmentsVm>>> GetOpportunityAttachments(GetOpportunityAttachmentsQuery getOpportunityAttachments)
        {
            var dtos = await _mediator.Send(getOpportunityAttachments);
            return Ok(dtos);
        }
        [HttpPost("changeStatus", Name = "ChangeOpportunityStatus")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> ChangeOpportunityStatus(ChangeOpportunityStatusCommand command)
        {
            var dtos = await _mediator.Send(command);
            return Ok(dtos);
        }
    }
}
