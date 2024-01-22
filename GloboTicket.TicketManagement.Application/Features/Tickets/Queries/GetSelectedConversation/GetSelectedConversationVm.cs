using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tickets.Queries.GetSelectedConversation
{
    public class GetSelectedConversationVm
    {
        public int ConversationId { get; set; }
        public int TicketId { get; set; }
        public string FromId { get; set; }
        public string ToId { get; set; }
        public DateTime Timestamp { get; set; }
        public string MessageType { get; set; }
        public string MessageBody { get; set; }
        public string MediaType { get; set; }
        public bool? ReadStatus { get; set; }
        public string Reaction { get; set; }
        public bool? ForwardedStatus { get; set; }
        public string Location { get; set; }
        public string MessageStatus { get; set; }
        public DateTime CreatedDate { get; set; }
        public string EventType { get; set; }
        public string CustomerFeedback { get; set; }
        public int TenantId { get; set; }
        public bool IsMine { get; set; }
    }
}
