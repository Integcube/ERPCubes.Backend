using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Meeting.Commands.SaveMeeting
{
    public class SaveMeetingCommandHandler : IRequestHandler<SaveMeetingCommand>
    {
        private readonly IAsyncMeetingRepository _meetingRepository;
        private readonly ILogger<SaveMeetingCommandHandler> _logger;
        public SaveMeetingCommandHandler(IAsyncMeetingRepository meetingRepository, ILogger<SaveMeetingCommandHandler> logger)
        {
            _meetingRepository = meetingRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveMeetingCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _meetingRepository.SaveMeeting(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving Meeting {request.MeetingId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
