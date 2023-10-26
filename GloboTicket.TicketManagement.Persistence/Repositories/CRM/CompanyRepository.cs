using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Features.Company.Queries.GetCompanyList;
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
    public class CompanyRepository : BaseRepository<CrmCompany>, IAsyncCompanyRepository
    {

        public CompanyRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity) { }

        public Task DeleteCompany(string Id, int TenantId, int companyId)
        {
            throw new NotImplementedException();
        }

        public async Task<List<GetCompanyVm>> GetAllList(string Id, int TenantId)
        {
            List<GetCompanyVm> companyDetail = await (from a in _dbContext.CrmCompany.Where(a => a.TenantId == TenantId && a.IsDeleted == 0)
                                                select new GetCompanyVm
                                                {
                                                    CompanyId = a.CompanyId,
                                                    Name = a.Name,
                                                    Website = a.Website,
                                                    CompanyOwner = a.CompanyOwner,
                                                    Mobile = a.Mobile,
                                                    Work = a.Work,
                                                    BillingAddress = a.BillingAddress,
                                                    BillingStreet = a.BillingStreet,
                                                    BillingCity = a.BillingCity,
                                                    BillingZip = a.BillingZip,
                                                    BillingState = a.BillingState,
                                                    BillingCountry = a.BillingCountry,
                                                    DeliveryAddress = a.DeliveryAddress,
                                                    DeliveryStreet = a.DeliveryStreet,
                                                    DeliveryCity = a.DeliveryCity,
                                                    DeliveryZip = a.DeliveryZip,
                                                    DeliveryState = a.DeliveryState,
                                                    DeliveryCountry = a.DeliveryCountry,
                                                    IndustryId = a.IndustryId,
                                                    CreatedDate = a.CreatedDate
                                                }).ToListAsync();
            return companyDetail;
        }
    }
}
