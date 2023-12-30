using ERPCubes.Application.Features.Crm.Campaign.Commands.DeleteCampaign;
using ERPCubes.Application.Features.Crm.Campaign.Commands.SaveCampaign;
using ERPCubes.Application.Features.Crm.Campaign.Queries.GetCampaign;
using ERPCubes.Application.Features.Crm.Campaign.Queries.GetCampaignSource;
﻿using ERPCubes.Application.Features.Crm.Campaign.Commands.SaveCampaign;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CampaignController : ControllerBase
    {
        private readonly IMediator _mediator;
        public CampaignController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [HttpPost("saveBulk", Name = "SaveBulkCampaign")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> SaveBulkCampaign(SaveBulkCampaignCommand saveCampaign)
        {
            var dtos = await _mediator.Send(saveCampaign);
            return Ok(dtos);
        }
        [HttpPost("save", Name = "SaveCampaign")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> SaveCampaign(SaveCampaignCommand saveCampaign)
        {
            var dtos = await _mediator.Send(saveCampaign);
            return Ok(dtos);
        }
        [HttpPost("all", Name = "GetCampaign")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> GetCampaign(GetCampaignQuery getCampaign)
        {
            var dtos = await _mediator.Send(getCampaign);
            return Ok(dtos);
        }
        [HttpPost("delete", Name = "DeleteCampaign")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> DeleteCampaign(DeleteCampaignCommand deleteCampaign)
        {
            var dtos = await _mediator.Send(deleteCampaign);
            return Ok(dtos);
        }
        [HttpPost("allSources", Name = "GetCampaignSources")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> GetCampaignSources(GetCampaignSourceQuery getCampaignSource)
        {
            var dtos = await _mediator.Send(getCampaignSource);
            return Ok(dtos);
        }
    }
}
