using ERPCubes.Application.Features.Tickets.Queries.GetAllTickets;
using Microsoft.AspNetCore.SignalR;

namespace ERPCubesApi.Hubs
{
    public class ChatHub:Hub
    {
        public async Task SendTicketToTenant(string tenantId, GetAllTicketsVm ticket)
        {
            // Send ticket data to the group corresponding to the specific tenant
            await Clients.Group(tenantId).SendAsync("ReceiveNewTicket", ticket);
        }

        public async Task SendTicketToChatBot(string chatBotId, GetAllTicketsVm ticket)
        {
            // Send ticket data to the group corresponding to the specific chat bot
            await Clients.Group(chatBotId).SendAsync("ReceiveNewTicket", ticket);
        }

        public override async Task OnConnectedAsync()
        {
            var httpContext = Context.GetHttpContext();
            var tenantId = httpContext.Request.Query["tenantId"]; // Get tenant ID from query string
            var chatBotId = httpContext.Request.Query["chatBotId"]; // Get chat bot ID from query string

            // Add the connection to the corresponding groups
            if (!string.IsNullOrEmpty(tenantId))
                await Groups.AddToGroupAsync(Context.ConnectionId, tenantId);

            if (!string.IsNullOrEmpty(chatBotId))
                await Groups.AddToGroupAsync(Context.ConnectionId, chatBotId);

            await base.OnConnectedAsync();
        }
    }
}
