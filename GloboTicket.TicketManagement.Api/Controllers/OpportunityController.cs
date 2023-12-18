using ERPCubes.Application.Features.Crm.Lead.Commands.DeleteLead;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadList;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSource;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.DeleteOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Commands.SaveOpportunity;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunity;
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
        public async Task<ActionResult<List<GetLeadVm>>> GetAllOpportunity(GetOpportunityQuery getOpportunity)
        {
            var dtos = await _mediator.Send(getOpportunity);
            return Ok(dtos);
        }
        //[Authorize]
        [HttpPost("allSource", Name = "GetAllOpportunitySource")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetLeadVm>>> GetAllOpportunitySource(GetOpportunitySourceQuery getOpportunitySource)
        {
            var dtos = await _mediator.Send(getOpportunitySource);
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
    }
}
