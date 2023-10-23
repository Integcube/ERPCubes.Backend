using ERPCubes.Application.Features.AppMenu.Queries.GetMenuList;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AppMenuController : ControllerBase
    {
        private readonly IMediator _mediator;

        public AppMenuController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [Authorize]
        [HttpGet("all", Name = "GetAllMenu")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<AppMenuDto>> GetAllMenu()
        {
            var dtos = (await _mediator.Send(new GetAppMenuListQuery()));
            return Ok(dtos);
        }
    }
}
