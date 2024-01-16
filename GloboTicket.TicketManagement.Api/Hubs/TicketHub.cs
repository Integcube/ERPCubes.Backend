using ERPCubesApi.Hubs.HubDtos;
using Microsoft.AspNetCore.SignalR;

namespace ERPCubesApi.Hubs
{
    public class TicketHub : Hub
    {
        public async Task NotifyNewTicket(TicketNotify ticket)
        {
            await Clients.All.SendAsync("ReceiveNewTicket", ticket);
        }
    }
}
