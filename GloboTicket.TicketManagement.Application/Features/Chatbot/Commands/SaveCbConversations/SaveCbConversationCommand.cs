using ERPCubes.Application.Features.Chatbot.Queries.GetAllConversations;
using ERPCubes.Application.Features.Tickets.Queries.GetAllTickets;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Chatbot.Commands.SaveCbConversations
{
    public class SaveCbConversationCommand:IRequest<GetAllTicketsVm>
    {
        public string TenantId { get; set; }
        public string BrowserId { get; set; }
        public string Message { get; set; }
    }
}
