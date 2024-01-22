using ERPCubes.Application.Features.Tickets.Queries.GetSelectedConversation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tickets.Queries.GetAllTickets
{
    public class GetAllTicketsVm
    {
        public int TicketId { get; set; }
        public string SocialMediaPlatform { get; set; }
        public string CustomerId { get; set; }
        public DateTime Timestamp { get; set; }
        public string Status { get; set; }
        public string AssigneeId { get; set; }
        public string Priority { get; set; }
        public string Category { get; set; }
        public string ResolutionStatus { get; set; }
        public DateTime DueDate { get; set; }
        public DateTime RecentlyActive { get; set; }
        public string Notes { get; set; }
        public GetSelectedConversationVm LatestConversation { get; set; }
        public int TenantId { get; set; }
    }
}
