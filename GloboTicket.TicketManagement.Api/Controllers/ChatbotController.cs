using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Application.Features.Chatbot.Commands.SaveCbConversations;
using ERPCubes.Application.Features.Chatbot.Queries.GetAllConversations;
using ERPCubesApi.Hubs;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using static ERPCubesApi.Controllers.ConnectGoogleController;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ChatbotController : ControllerBase
    {
        private readonly IMediator _mediator;
        private readonly IHubContext<TicketHub> _hubContext;

        public ChatbotController(IMediator mediator, IHubContext<TicketHub> hubContext)
        {
            _mediator = mediator;
            _hubContext = hubContext;
        }
        [HttpPost("all", Name = "GetAllConversation")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetCbConversationVm>>> GetAllUsers(GetCbConversationQueries getConversation)
        {
            var dto = await _mediator.Send(getConversation);
            return Ok(dto);
        }
        [HttpPost("save", Name = "SaveConversation")]
        public async Task<ActionResult<GetCbConversationVm>> SaveConversation(SaveCbConversationCommand saveConversation)
        {
            var dto = await _mediator.Send(saveConversation);
            await _hubContext.Clients.All.SendAsync("ReceiveNewTicket", dto);

            return Ok(dto);
        }
    }
}
