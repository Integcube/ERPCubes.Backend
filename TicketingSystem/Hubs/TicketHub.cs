using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System;
using TicketingSystem.Services;
using Microsoft.AspNetCore.SignalR;
using TicketingSystem.Dtos;

namespace TicketingSystem.Hubs
{
    public class TicketHub:Hub
    {
        private readonly TicketingService _ticketService;
        public TicketHub(TicketingService ticketService)
        {
            _ticketService = ticketService;
        }

        public override async Task OnConnectedAsync()
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, "Come2Chat");
            await Clients.Caller.SendAsync("UserConnected");
        }

        public override async Task OnDisconnectedAsync(Exception exception)
        {
            var user = _ticketService.GetUserByConnectionId(Context.ConnectionId);
            if (user != null)
            {
                var tenantId = GetUserTenantId(user);
                await Groups.RemoveFromGroupAsync(Context.ConnectionId, tenantId);
                _ticketService.RemoveUserFromList(tenantId, user);
                await DisplayOnlineUsers(tenantId);
            }

            await base.OnDisconnectedAsync(exception);
        }

        public async Task AddUserConnectionId(string name, string tenantId)
        {
            _ticketService.AddUserConnectionId(tenantId, name, Context.ConnectionId);
            await DisplayOnlineUsers(tenantId);
        }

        public async Task ReceiveMessage(MessageDto message, string tenantId)
        {
            await Clients.Group(tenantId).SendAsync("NewMessage", message);
        }

        public async Task CreatePrivateChat(MessageDto message, string tenantId)
        {
            string privateGroupName = GetPrivateGroupName(message.From, message.To);
            await Groups.AddToGroupAsync(Context.ConnectionId, privateGroupName);
            var toConnectionId = _ticketService.GetConnectionIdByUser(tenantId, message.To);
            await Groups.AddToGroupAsync(toConnectionId, privateGroupName);

            // Opening private chatbox for the other end user
            await Clients.Client(toConnectionId).SendAsync("OpenPrivateChat", message);
        }

        public async Task RecivePrivateMessage(MessageDto message, string tenantId)
        {
            string privateGroupName = GetPrivateGroupName(message.From, message.To);
            await Clients.Group(privateGroupName).SendAsync("NewPrivateMessage", message);
        }

        public async Task RemovePrivateChat(string from, string to, string tenantId)
        {
            string privateGroupName = GetPrivateGroupName(from, to);
            await Clients.Group(privateGroupName).SendAsync("CloseProivateChat");

            await Groups.RemoveFromGroupAsync(Context.ConnectionId, privateGroupName);
            var toConnectionId = _ticketService.GetConnectionIdByUser(tenantId, to);
            await Groups.RemoveFromGroupAsync(toConnectionId, privateGroupName);
        }

        private async Task DisplayOnlineUsers(string tenantId)
        {
            var onlineUsers = _ticketService.GetOnlineUsers(tenantId);
            await Clients.Groups(tenantId).SendAsync("OnlineUsers", onlineUsers);
        }

        private string GetPrivateGroupName(string from, string to)
        {
            // Assuming from and to are tenant IDs
            var stringCompare = string.CompareOrdinal(from, to) < 0;
            return stringCompare ? $"{from}-{to}" : $"{to}-{from}";
        }

        private string GetUserTenantId(string userName)
        {
            // Implement logic to get tenant ID for a user
            // For example, you might have a mapping of users to tenant IDs
            // Or extract tenant ID from the user name
            return "Tenant1"; // Replace with actual logic
        }
    }
}
