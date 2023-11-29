using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Calender.Commands.DeleteCalendarEvent;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Calender.Commands.SaveCalendarEvent
{
    public class SaveCalendarEventCommandHandler : IRequestHandler<SaveCalendarEventCommand>
    {
        private readonly IAsyncCalenderRepository _calenderRepository;
        private readonly ILogger<SaveCalendarEventCommandHandler> _logger;
        public  SaveCalendarEventCommandHandler(IAsyncCalenderRepository calenderRepository, ILogger<SaveCalendarEventCommandHandler> logger)
        {
            _calenderRepository = calenderRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveCalendarEventCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _calenderRepository.SaveCalendarEvent(request);
                return Unit.Value;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Save Calendar Event {request.Event.Title} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
