using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Email.Commands.DeleteEmail;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Meeting.Commands.DeleteMeeting
{
    public class DeleteMeetingCommandHandler : IRequestHandler<DeleteMeetingCommand>
    {
        private readonly IAsyncMeetingRepository _meetingRepository;
        private readonly ILogger<DeleteMeetingCommandHandler> _logger;
        public DeleteMeetingCommandHandler(IAsyncMeetingRepository meetingRepository, ILogger<DeleteMeetingCommandHandler> logger)
        {
            _meetingRepository = meetingRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(DeleteMeetingCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _meetingRepository.DeleteMeeting(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting meeting {request.MeetingId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
