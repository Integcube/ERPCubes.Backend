using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Tickets.Queries.GetSelectedConversation;
using ERPCubes.Application.Features.Tickets.Queries.GetTicketPriorityList.GetTicketPriorityList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tickets.Queries.GetTicketPriorityList
{
    public class GetTicketPriorityListQueryHandler : IRequestHandler<GetTicketPriorityListQuery, List<GetTicketPriorityListVm>>
    {
        private readonly IAsyncTicketRepository _ticketRepository;
        private readonly ILogger<GetTicketPriorityListQueryHandler> _logger;
        public GetTicketPriorityListQueryHandler(IAsyncTicketRepository ticketRepository, ILogger<GetTicketPriorityListQueryHandler> logger)
        {
            _logger = logger;
            _ticketRepository = ticketRepository;
        }
        public async Task<List<GetTicketPriorityListVm>> Handle(GetTicketPriorityListQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetTicketPriorityListVm> message = await _ticketRepository.GetTicketPriority(request);
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
