using ERPCubes.Application.Features.Crm.AdAccount.SaveAdAccount;
using ERPCubes.Application.Features.Crm.Campaign.Commands.SaveCampaign;
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
        [HttpPost("save", Name = "SaveCampaign")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> SaveCampaign(SaveCampaignCommand saveCampaign)
        {
            var dtos = await _mediator.Send(saveCampaign);
            return Ok(dtos);
        }
        //[HttpPost("saveAll", Name = "SaveCampaigns")]
        //[ProducesResponseType(StatusCodes.Status204NoContent)]
        //[ProducesResponseType(StatusCodes.Status404NotFound)]
        //public async Task<ActionResult> SaveCampaigns(SaveCampaignCommand saveCampaigns)
        //{
        //    var dtos = await _mediator.Send(saveCampaigns);
        //    return Ok(dtos);
        //}
    }
}
