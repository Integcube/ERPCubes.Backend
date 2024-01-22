using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Tickets.Queries.GetTicketPriorityList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tickets.Queries.GetTicketStatusList
{
    public class GetTicketStatusListQueryHandler : IRequestHandler<GetTicketStatusListQuery, List<GetTicketStatusListVm>>
    {
        private readonly IAsyncTicketRepository _ticketRepository;
        private readonly ILogger<GetTicketStatusListQueryHandler> _logger;
        public GetTicketStatusListQueryHandler(IAsyncTicketRepository ticketRepository, ILogger<GetTicketStatusListQueryHandler> logger)
        {
            _logger = logger;
            _ticketRepository = ticketRepository;
        }
        public async Task<List<GetTicketStatusListVm>> Handle(GetTicketStatusListQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetTicketStatusListVm> message = await _ticketRepository.GetTicketStatus(request);
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
