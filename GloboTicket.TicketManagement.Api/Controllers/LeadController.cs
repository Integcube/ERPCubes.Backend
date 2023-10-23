using ERPCubes.Application.Features.Lead.Queries.GetLeadList;
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
        [HttpPost("all", Name = "GetAllLeads")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<LeadVm>>> GetAllCategories(GetLeadListQuery getLeadList)
        {
            var dtos = await _mediator.Send(getLeadList);
            return Ok(dtos);
        }
    }
}
