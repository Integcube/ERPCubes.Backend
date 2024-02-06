using ERPCubes.Application.Features.Crm.Team.Queries.GetTeams;
using ERPCubes.Application.Features.TenantChecker;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TenantController : ControllerBase
    {
        private readonly IMediator _mediator;
        public TenantController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [HttpPost("checkTenant")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<bool>> CheckTenant(TenantCheckerQuery checker)
        {
            var dtos = await _mediator.Send(checker);
            return Ok(dtos);
        }
    }
}
