using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Chatbot.Queries.GetAllConversations
{
    public class GetCbConversationQueries:IRequest<List<GetCbConversationVm>>
    {
        public string TenantId { get; set; }
        public string BrowserId { get; set; }
    }
}
