using AutoMapper;
using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Tickets.Commands.SendMessage;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tickets.Commands.SaveTicketInfo
{
    public class SaveTicketInfoCommandHandler : IRequestHandler<SaveTicketInfoCommand>
    {
        private readonly IAsyncTicketRepository _ticketRepository;
        private readonly ILogger<SaveTicketInfoCommandHandler> _logger;

        public SaveTicketInfoCommandHandler(IAsyncTicketRepository ticketRepository, ILogger<SaveTicketInfoCommandHandler> logger)
        {
            _logger = logger;
            _ticketRepository = ticketRepository;
        }

        public async Task<Unit> Handle(SaveTicketInfoCommand request, CancellationToken cancellationToken)
        {
            try
            {

                 await _ticketRepository.SaveTicketInfo(request);
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
