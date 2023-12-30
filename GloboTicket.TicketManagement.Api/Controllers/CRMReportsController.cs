using ERPCubes.Application.Features.Crm.Lead.Queries.GetleadPiplineReport;
using ERPCubes.Application.Features.Crm.Reports.Queries.GetCampaigWiseReport;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CRMReportsController : ControllerBase
    {
        private readonly IMediator _mediator;
        public CRMReportsController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpPost("GetCampaigWiseReport", Name = "GetCampaigWiseReport")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> GetCampaigWiseReport(GetCampaigWiseReportQuery leadReport)
        {
            var dtos = await _mediator.Send(leadReport);
            return Ok(dtos);
        }
    }
}
