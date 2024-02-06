using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Tickets.Queries.GetAllTickets;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Chatbot.Queries.GetAllConversations
{
    public class GetCbConversationQueriesHandler : IRequestHandler<GetCbConversationQueries, List<GetCbConversationVm>>
    {
        private readonly IAsyncChatbotRepository _chatbotRepository;
        private readonly ILogger<GetAllTicketsQueryHandler> _logger;
        public GetCbConversationQueriesHandler(IAsyncChatbotRepository chatbotRepository, ILogger<GetAllTicketsQueryHandler> logger)
        {
            _logger = logger;
            _chatbotRepository = chatbotRepository;
        }
        public async Task<List<GetCbConversationVm>> Handle(GetCbConversationQueries request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetCbConversationVm> message = await _chatbotRepository.GetAllConversation(request);
                return message;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Get Chatbot Conversation caused error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
