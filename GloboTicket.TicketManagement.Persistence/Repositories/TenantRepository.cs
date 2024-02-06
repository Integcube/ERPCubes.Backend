using ERPCubes.Application.Contracts.Persistence.TenantChecker;
using ERPCubes.Application.Exceptions;
using ERPCubes.Identity;
using ERPCubes.Identity.Models;
using Microsoft.EntityFrameworkCore;

namespace ERPCubes.Persistence.Repositories
{
    public class TenantRepository : BaseRepository<Task>, IAsyncTenantRepository
    {
        public TenantRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task<bool> CheckTenant(string subdomain)
        {
            try
            {
                Tenant tenant = await (from a in _dbContextIdentity.Tenant.Where(a => a.Subdomain == subdomain)
                                       select a).FirstOrDefaultAsync();
                if(tenant == null)
                {
                    return false;
                }
                return true;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
