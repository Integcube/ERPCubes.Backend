using ERPCubes.Application.Features.Crm.AdAccount.Commands.SaveAdAccount;
using ERPCubes.Application.Features.Notification.Commands.SaveNotification;
using ERPCubes.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.Notifications
{
    public interface IAsyncNotificationRepository
    {
        Task<Notification> SaveNotification(SaveNotificationCommand notification);
    }
}
