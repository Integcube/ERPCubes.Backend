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

namespace ERPCubes.Application.Features.Tickets.Queries.GetSelectedConversation
{
    public class GetSelectedConversationQueryHandler : IRequestHandler<GetSelectedConversationQuery, List<GetSelectedConversationVm>>
    {
        private readonly IAsyncTicketRepository _ticketRepository;
        private readonly ILogger<GetSelectedConversationQueryHandler> _logger;
        public GetSelectedConversationQueryHandler(IAsyncTicketRepository ticketRepository, ILogger<GetSelectedConversationQueryHandler> logger)
        {
            _logger = logger;
            _ticketRepository = ticketRepository;
        }
        public async Task<List<GetSelectedConversationVm>> Handle(GetSelectedConversationQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetSelectedConversationVm> message = await _ticketRepository.GetSelectedConversation(request);
                return message;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving Instagram message caused error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
