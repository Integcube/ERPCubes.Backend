using ERPCubes.Application.Contracts.Notifications;
using ERPCubes.Application.Features.Notification.Commands.SaveNotification;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Persistence.Repositories
{
    public class NotificationRepository : BaseRepository<Notification>, IAsyncNotificationRepository
    {
        public NotificationRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity) { }

        public async Task<Notification> SaveNotification(SaveNotificationCommand notification)
        {
            try
            {
                Notification notify = new Notification();
                notify.Icon = notification.Notification.Icon;
                notify.Image = notification.Notification.Image;
                notify.Link  = notification.Notification.Link;
                notify.Title = notification.Notification.Title;
                notify.Description = notification.Notification.Description;
                notify.UseRouter = notification.Notification.UseRouter;
                notify.CreatedBy = notification.Id;
                notify.CreatedDate = DateTime.Now.ToUniversalTime();
                notify.IsDeleted = 0;
                notify.TenantId = notification.TenantId;
                await _dbContext.AddAsync(notify);

                await _dbContext.SaveChangesAsync();
                return notify;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);

            }
        }
    }
}
