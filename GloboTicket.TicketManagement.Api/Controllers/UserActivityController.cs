using ERPCubes.Application.Features.Crm.UserActivity.Queries.GetUserActivity;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserActivityController : ControllerBase
    {
        private readonly IMediator _mediator;
        public UserActivityController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpPost("Get")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetUserActivityVm>>> GetUserActivityAsync(GetUserActivityQuery request)
        {
            var dtos = await _mediator.Send(request);
            return Ok(dtos);
        }
    }
}
