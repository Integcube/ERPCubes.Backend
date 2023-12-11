using ERPCubes.Application.Features.Crm.Activity.Queries.GetUserActivityReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadReport;
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
        
        [HttpPost("activityReport", Name = "GetUserActivityReport")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetUserActivityReport(GetUserActivityReportQuery leadReport)
        {
            var dtos = await _mediator.Send(leadReport);
            return Ok(dtos);
        }
    }
}
