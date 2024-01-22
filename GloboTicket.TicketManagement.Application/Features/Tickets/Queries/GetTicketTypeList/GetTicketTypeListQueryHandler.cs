using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Tickets.Queries.GetTicketStatusList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tickets.Queries.GetTicketTypeList
{
    public class GetTicketTypeListQueryHandler : IRequestHandler<GetTicketTypeListQuery, List<GetTicketTypeListVm>>
    {
        private readonly IAsyncTicketRepository _ticketRepository;
        private readonly ILogger<GetTicketTypeListQueryHandler> _logger;
        public GetTicketTypeListQueryHandler(IAsyncTicketRepository ticketRepository, ILogger<GetTicketTypeListQueryHandler> logger)
        {
            _logger = logger;
            _ticketRepository = ticketRepository;
        }
        public async Task<List<GetTicketTypeListVm>> Handle(GetTicketTypeListQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetTicketTypeListVm> message = await _ticketRepository.GetTicketType(request);
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
