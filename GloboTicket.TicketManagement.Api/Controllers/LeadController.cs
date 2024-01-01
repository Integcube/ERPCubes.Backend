using ERPCubes.Application.Features.Crm.Lead.Commands.BulkSaveLead;
using ERPCubes.Application.Features.Crm.Lead.Commands.DeleteLead;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadByMonth;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadList;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadOwnerWiseReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetleadPiplineReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSource;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSourceWiseReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadStatus;
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
    }
}
