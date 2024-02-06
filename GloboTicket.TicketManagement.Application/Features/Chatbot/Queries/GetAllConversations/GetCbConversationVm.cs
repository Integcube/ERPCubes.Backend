using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Chatbot.Queries.GetAllConversations
{
    public class GetCbConversationVm
    {
        public int TicketId { get; set; }
        public int ConversationId { get; set; }
        public DateTime Timestamp { get; set; }
        public string Message { get; set; }
        public bool IsMine { get; set; }
    }
}
