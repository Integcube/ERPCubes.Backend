using ERPCubes.Application.Features.Crm.Email.Queries.GetEmailList;
using ERPCubes.Application.Features.Tickets.Commands.SendMessage;
using ERPCubes.Application.Features.Tickets.Commands.SetReadStatus;
using ERPCubes.Application.Features.Tickets.Queries.GetAllTickets;
using ERPCubes.Application.Features.Tickets.Queries.GetSelectedConversation;
using ERPCubesApi.Hubs;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using static ERPCubesApi.Controllers.ConnectGoogleController;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TicketController : ControllerBase
    {
        private readonly IMediator _mediator;
        private readonly IHubContext<TicketHub> _hubContext;

        public TicketController(IMediator mediator, IHubContext<TicketHub> hubContext)
        {
            _mediator = mediator;
            _hubContext = hubContext;

        }
        [HttpPost("allTickets", Name = "GetAllTickets")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetAllTicketsVm>>> GetAllTickets(GetAllTicketsQuery ticket)
        {
            var dtos = await _mediator.Send(ticket);
            return Ok(dtos);
        }
        [HttpPost("allConversation", Name = "GetAllConversations")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetSelectedConversationVm>>> GetAllConversations(GetSelectedConversationQuery conversation)
        {
            var dtos = await _mediator.Send(conversation);
            return Ok(dtos);
        }
        [HttpPost("setReadStatus", Name = "SetReadStatus")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task SetReadStatus(SetReadStatusCommand ticket)
        {
           await _mediator.Send(ticket);
        }
        [HttpPost("sendMessage", Name = "SendMessage")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task SendMessage(SendMessageCommand ticket)
        {
            var message = await _mediator.Send(ticket);
            await _hubContext.Clients.All.SendAsync("ReceiveNewTicket", message);

        }
    }
}
