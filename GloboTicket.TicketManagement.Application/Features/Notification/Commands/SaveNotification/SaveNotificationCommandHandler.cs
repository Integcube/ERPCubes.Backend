using AutoMapper;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Contracts.Persistence.Notifications;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Notes.Commands.SaveNote;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Notification.Commands.SaveNotification
{
    public class SaveNotificationCommandHandler : IRequestHandler<SaveNotificationCommand, SaveNotificationVm>
    {
        private readonly IAsyncNotificationRepository _notificationRepository;
        private readonly ILogger<SaveNotificationCommandHandler> _logger;
        private readonly IMapper _mapper;
        public SaveNotificationCommandHandler(IAsyncNotificationRepository NotificationRepository, ILogger<SaveNotificationCommandHandler> logger, IMapper mapper)
        {
            _notificationRepository = NotificationRepository;
            _logger = logger;
            _mapper = mapper;
        }
        public async Task<SaveNotificationVm> Handle(SaveNotificationCommand request, CancellationToken cancellationToken)
        {
            try
            {
               var notifiation = _mapper.Map<SaveNotificationVm>(await _notificationRepository.SaveNotification(request));
                return notifiation;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving Notification :{request.Notification.Title} failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
