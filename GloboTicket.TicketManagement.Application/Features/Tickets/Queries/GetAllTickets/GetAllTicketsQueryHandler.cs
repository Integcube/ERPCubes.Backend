using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Contracts.Persistence.Social.Webhooks;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Social.Webhooks.Instagram.Commands;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tickets.Queries.GetAllTickets
{
    public class GetAllTicketsQueryHandler : IRequestHandler<GetAllTicketsQuery, List<GetAllTicketsVm>>
    {
        private readonly IAsyncTicketRepository _ticketRepository;
        private readonly ILogger<GetAllTicketsQueryHandler> _logger;
        public GetAllTicketsQueryHandler(IAsyncTicketRepository ticketRepository, ILogger<GetAllTicketsQueryHandler> logger)
        {
            _logger = logger;
            _ticketRepository = ticketRepository;
        }
        public async Task<List<GetAllTicketsVm>> Handle(GetAllTicketsQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetAllTicketsVm> message = await _ticketRepository.GetAllTickets(request);
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
