using ERPCubes.Application.Features.Crm.AdAccount.Commands.SaveAdAccount;
using ERPCubes.Application.Features.Notification.Commands.SaveNotification;
using ERPCubes.Application.Models.Authentication;
using ERPCubesApi.Hubs;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotificationController : ControllerBase
    {
        private readonly IMediator _mediator;
        private readonly IHubContext<TicketHub> _hubContext;
        public NotificationController(IMediator mediator, IHubContext<TicketHub> hubContext)
        {
            _mediator = mediator;
            _hubContext = hubContext;
        }
        [HttpPost("save", Name = "SaveNotification")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> SaveNotification(SaveNotificationCommand saveNotification)
        {
            var dtos = await _mediator.Send(saveNotification);

            await _hubContext.Clients.All.SendAsync("ReceiveNewTicket", dtos);
            return Ok(dtos);
        }
    }
}
