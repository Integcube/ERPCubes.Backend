using MediatR;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Notification.Commands.SaveNotification
{
    public class SaveNotificationCommand:IRequest<SaveNotificationVm>
    {
        public int TenantId { get; set; }
        public string Id { get; set; }
        public SaveNotificationDto Notification { get; set; }
    }
}
