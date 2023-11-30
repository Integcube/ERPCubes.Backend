using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Features.Crm.UserActivity.Queries.GetUserActivity;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class ActivityRepository : BaseRepository<CrmUserActivityLog>, IAsyncUserActivityRepository
    {
        public ActivityRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity)
            : base(dbContext, dbContextIdentity) { }
        public async Task<List<GetUserActivityVm>> GetUserActivityListAsync(GetUserActivityQuery request)
        {
            try
            {
            var Activitylist = await (
              from a in _dbContext.CrmUserActivityLog.Where(a => a.TenantId == request.TenantId && a.IsDeleted == 0 && (request.LeadId != -1 || request.CompanyId != -1 || a.UserId == request.Id || a.CreatedBy == request.Id) && (request.CompanyId == -1 || a.Id == request.CompanyId) && (request.LeadId == -1 || a.Id == request.LeadId))
              join b in _dbContext.CrmUserActivityType on a.ActivityType equals b.ActivityTypeId into all
              from c in all.DefaultIfEmpty()
              orderby a.CreatedDate descending
              select new GetUserActivityVm
              {
                  ActivityId = a.ActivityId,
                  UserId = a.UserId,
                  ActivityStatus = a.ActivityStatus,
                  Detail = a.Detail,
                  CreatedDate = a.CreatedDate,
                  CreatedBy = a.CreatedBy,
                  ActivityType = c.ActivityTypeTitle,
                  Icon = c.Icon,
                  ActivityTypeId = c.ActivityTypeId
              }).Take(request.Count * 10).ToListAsync();
                return Activitylist;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
          
            
        }
    }
}
