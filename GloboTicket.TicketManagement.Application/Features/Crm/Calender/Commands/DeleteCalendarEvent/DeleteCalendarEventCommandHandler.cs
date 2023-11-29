using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Calender.Queries.GetCalendarTypeList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Calender.Commands.DeleteCalendarEvent
{
    public class DeleteCalendarEventCommandHandler : IRequestHandler<DeleteCalendarEventCommand>
    {
        private readonly IAsyncCalenderRepository _calenderRepository;
        private readonly ILogger<DeleteCalendarEventCommandHandler> _logger;
        public DeleteCalendarEventCommandHandler(IAsyncCalenderRepository calenderRepository, ILogger<DeleteCalendarEventCommandHandler> logger)
        {
            _calenderRepository = calenderRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(DeleteCalendarEventCommand request, CancellationToken cancellationToken)
        {
            try
            {
               await _calenderRepository.DeleteCalendarEvent(request);
                return Unit.Value;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting Calendar Event {request.Title} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
