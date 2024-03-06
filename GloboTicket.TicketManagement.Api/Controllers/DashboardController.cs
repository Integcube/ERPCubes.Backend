using ERPCubes.Application.Features.Crm.Dashboard.Commands.DeleteDashboard;
using ERPCubes.Application.Features.Crm.Dashboard.Commands.SaveDashboard;
using ERPCubes.Application.Features.Crm.Dashboard.Queries.GetDashboards;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DashboardController : ControllerBase
    {
        private readonly IMediator _mediator;
        public DashboardController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [HttpPost("all", Name = "GetAllDashboards")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetDashboardVm>>> GetAllLeads(GetDashboardQuery getDashboard)
        {
            var dtos = await _mediator.Send(getDashboard);
            return Ok(dtos);
        }
        [HttpPost("delete", Name = "DeleteDashboard")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> DeleteDashboard(DeleteDashboardCommand dashboard)
        {
            var dtos = await _mediator.Send(dashboard);
            return Ok(dtos);
        }
        [HttpPost("save", Name = "SaveDashboard")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> SaveLead(SaveDashboardCommand dashboard)
        {
            var dtos = await _mediator.Send(dashboard);
            return Ok(dtos);
        }
    }
}
