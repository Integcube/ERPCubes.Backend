using ERPCubes.Application.Features.Crm.Email.Queries.GetEmailList;
using ERPCubes.Application.Features.Tickets.Commands.SaveTicketInfo;
using ERPCubes.Application.Features.Tickets.Commands.SendMessage;
using ERPCubes.Application.Features.Tickets.Commands.SetReadStatus;
using ERPCubes.Application.Features.Tickets.Queries.GetAllTickets;
using ERPCubes.Application.Features.Tickets.Queries.GetSelectedConversation;
using ERPCubes.Application.Features.Tickets.Queries.GetTicketPriorityList;
using ERPCubes.Application.Features.Tickets.Queries.GetTicketPriorityList.GetTicketPriorityList;
using ERPCubes.Application.Features.Tickets.Queries.GetTicketStatusList;
using ERPCubes.Application.Features.Tickets.Queries.GetTicketTypeList;
using ERPCubes.Domain.Entities;
using ERPCubesApi.Hubs;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using static ERPCubesApi.Controllers.ConnectGoogleController;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TicketController : ControllerBase
    {
        private readonly IMediator _mediator;
        private readonly IHubContext<TicketHub> _hubContext;
        private readonly IHubContext<ChatHub> _chatHubContext;

        public TicketController(IMediator mediator, IHubContext<TicketHub> hubContext, IHubContext<ChatHub> chatHubContext)
        {
            _mediator = mediator;
            _hubContext = hubContext;
            _chatHubContext = chatHubContext;
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
        [HttpPost("getPriority", Name = "GetPriority")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetTicketPriorityListVm>>> GetPriority(GetTicketPriorityListQuery ticket)
        {
            var priority = await _mediator.Send(ticket);
            return Ok(priority);
        }
        [HttpPost("getStatus", Name = "GetStatus")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetTicketStatusListVm>>> GetStatus(GetTicketStatusListQuery ticket)
        {
            var status = await _mediator.Send(ticket);
            return Ok(status);
        }
        [HttpPost("getType", Name = "GetType")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetTicketTypeListVm>>> GetType(GetTicketTypeListQuery ticket)
        {
            var priority = await _mediator.Send(ticket);
            return Ok(priority);
        }
        [HttpPost("saveInfo", Name = "SaveInfo")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task SaveInfo(SaveTicketInfoCommand ticket)
        {
            await _mediator.Send(ticket);
        }
    }
}
