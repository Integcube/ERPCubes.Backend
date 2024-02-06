using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Chatbot.Queries.GetAllConversations;
using ERPCubes.Application.Features.Tickets.Queries.GetAllTickets;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Chatbot.Commands.SaveCbConversations
{
    public class SaveCbConversationCommandHandler : IRequestHandler<SaveCbConversationCommand, GetAllTicketsVm>
    {
        private readonly IAsyncChatbotRepository _chatbotRepository;
        private readonly ILogger<SaveCbConversationCommandHandler> _logger;
        public SaveCbConversationCommandHandler(IAsyncChatbotRepository chatbotRepository, ILogger<SaveCbConversationCommandHandler> logger)
        {
            _logger = logger;
            _chatbotRepository = chatbotRepository;
        }
        public async Task<GetAllTicketsVm> Handle(SaveCbConversationCommand request, CancellationToken cancellationToken)
        {
            try
            {
                GetAllTicketsVm message = await _chatbotRepository.SaveConversation(request);
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
