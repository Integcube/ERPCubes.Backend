using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Features.Crm.UserActivity.Queries.GetUserActivity;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class UserActivityRepository : BaseRepository<CrmUserActivityLog>, IAsyncUserActivityRepository
    {
        public UserActivityRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity)
            : base(dbContext, dbContextIdentity) { }
        public async Task<List<GetUserActivityVm>> GetUserActivityListAsync(GetUserActivityQuery request)
        {
            var Activitylist = await (
                from a in _dbContext.CrmUserActivityLog.Where(a => a.TenantId == request.TenantId && a.IsDeleted == 0 && (a.UserId == request.Id || a.CreatedBy == request.Id))
                join b in _dbContext.CrmUserActivityType on a.ActivityType equals b.ActivityTypeId into all
                from c in all
                select new GetUserActivityVm
                {
                    ActivityId = a.ActivityId,
                    UserId = a.UserId,
                    ActivityStatus = a.ActivityStatus,
                    Detail = a.Detail,
                    Date = a.CreatedDate,
                    ActivityType = c.ActivityTypeTitle,
                    Icon = c.Icon,
                }).OrderByDescending(a => a.Date).ToListAsync();
            return Activitylist;
        }
    }
}
