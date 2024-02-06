using ERPCubes.Application.Features.Chatbot.Commands.SaveCbConversations;
using ERPCubes.Application.Features.Chatbot.Queries.GetAllConversations;
using ERPCubes.Application.Features.Tickets.Queries.GetAllTickets;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence
{
    public interface IAsyncChatbotRepository
    {
        Task<List<GetCbConversationVm>> GetAllConversation(GetCbConversationQueries request);
        Task<GetAllTicketsVm> SaveConversation(SaveCbConversationCommand request);

    }
}
