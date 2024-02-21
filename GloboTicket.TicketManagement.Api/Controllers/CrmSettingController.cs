
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead;
using ERPCubes.Application.Features.Crm.Meeting.Commands.DeleteMeeting;
using ERPCubes.Application.Features.Crm.Setting.Commands.Save;
using ERPCubes.Application.Features.Crm.Setting.Queries.GetChatBotSetting;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using static ERPCubesApi.Controllers.ConnectGoogleController;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CrmSettingController : ControllerBase
    {
        private readonly IMediator _mediator;
        public CrmSettingController(IMediator mediator)
        {
            _mediator = mediator;
        }



        [HttpPost("getchatbotsetting", Name = "GetChatbotSetting")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<GetChatBotSettingQuery>> GetChatbotSetting(GetChatBotSettingQuery request)
        {
            var dtos = await _mediator.Send(request);
            return Ok(dtos);
        }


        [HttpPost("savechatbot", Name = "Savechatbot")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> Savechatbot(SaveChatbotCommand leadCommand)
        {
            var dtos = await _mediator.Send(leadCommand);
            return Ok(dtos);
        }


    }
}
