using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Industry.Queries.GetIndustryList;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.Xml;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class IndustryRepository : BaseRepository<CrmIndustry>, IAsyncIndustryRepository
    {
        public IndustryRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task<List<GetIndustryListVm>> GetAllList(string Id, int TenantId)
        {
            try
            {
                List<GetIndustryListVm> IndustryList = await (from a in _dbContext.CrmIndustry.Where(a => a.IsDeleted == 0)
                                                              select new GetIndustryListVm
                                                              {
                                                                  IndustryId = a.IndustryId,
                                                                  IndustryTitle = a.IndustryTitle
                                                              }).ToListAsync();

                return IndustryList;
            }
            catch(Exception e)
            {
                throw new BadRequestException(e.Message);
            }
           
        }
    }
}
