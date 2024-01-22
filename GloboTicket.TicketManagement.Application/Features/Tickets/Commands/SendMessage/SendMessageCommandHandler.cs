using AutoMapper;
using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.AppMenu.Queries.GetMenuList;
using ERPCubes.Application.Features.Tickets.Commands.SetReadStatus;
using ERPCubes.Application.Features.Tickets.Queries.GetAllTickets;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tickets.Commands.SendMessage
{
    public class SendMessageCommandHandler : IRequestHandler<SendMessageCommand, SendMessageCommand>
    {
        private readonly IAsyncTicketRepository _ticketRepository;
        private readonly ILogger<SendMessageCommandHandler> _logger;
        private readonly IMapper _mapper;

        public SendMessageCommandHandler(IAsyncTicketRepository ticketRepository, ILogger<SendMessageCommandHandler> logger, IMapper mapper)
        {
            _logger = logger;
            _ticketRepository = ticketRepository;
            _mapper = mapper;

        }
        public async Task<SendMessageCommand> Handle(SendMessageCommand request, CancellationToken cancellationToken)
        {
            try
            {

                var data = await _ticketRepository.SendMessage(request);
                //var mappedData = _mapper.Map<GetAllTicketsVm>(data);
                return data;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Setting Read Status caused error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
