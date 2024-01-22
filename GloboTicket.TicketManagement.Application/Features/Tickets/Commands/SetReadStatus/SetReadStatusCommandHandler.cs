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

namespace ERPCubes.Application.Features.Tickets.Commands.SetReadStatus
{
    public class SetReadStatusCommandHandler : IRequestHandler<SetReadStatusCommand>
    {
        private readonly IAsyncTicketRepository _ticketRepository;
        private readonly ILogger<SetReadStatusCommandHandler> _logger;
        public SetReadStatusCommandHandler(IAsyncTicketRepository ticketRepository, ILogger<SetReadStatusCommandHandler> logger)
        {
            _logger = logger;
            _ticketRepository = ticketRepository;
        }
        public async Task<Unit> Handle(SetReadStatusCommand request, CancellationToken cancellationToken)
        {
            try
            {
                 await _ticketRepository.SetReadStatus(request);
                return Unit.Value;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Setting Read Status caused error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
