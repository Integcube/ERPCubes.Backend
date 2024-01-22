using ERPCubes.Application.Features.Tickets.Queries.GetAllTickets;
using ERPCubesApi.HubDtos;
using Microsoft.AspNetCore.SignalR;
using System.Text.RegularExpressions;

namespace ERPCubesApi.Hubs
{
    public class TicketHub : Hub
    {
        public async Task NotifyNewTicket(GetAllTicketsVm ticket)
        {
            var groupName = $"ClientId-{ticket.TicketId}";
            await Groups.AddToGroupAsync(Context.ConnectionId, groupName);
            await Clients.OthersInGroup(groupName).SendAsync("NotifyConversation", ticket.LatestConversation);
            await Clients.All.SendAsync("ReceiveNewTicket", ticket);
        }
    }
}
