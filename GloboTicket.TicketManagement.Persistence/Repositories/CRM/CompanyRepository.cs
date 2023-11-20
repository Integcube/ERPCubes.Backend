using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Company.Commands.SaveCompany;
using ERPCubes.Application.Features.Crm.Company.Queries.GetCompanyList;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
using System.Xml.Linq;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class CompanyRepository : BaseRepository<CrmCompany>, IAsyncCompanyRepository
    {

        public CompanyRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity) { }

        public async Task DeleteCompany(string Id, int TenantId, int CompanyId)
        {
            try
            {
                CrmCompany? comp = await (from a in _dbContext.CrmCompany.Where(a => a.CompanyId == CompanyId)
                                          select a).FirstOrDefaultAsync();
                if (comp == null)
                {
                    throw new NotFoundException("CompanyId", CompanyId);
                }
                else
                {
                    comp.IsDeleted = 1;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception e)
            {
                throw new BadRequestException(e.Message);
            }

        }

        public async Task<List<GetCompanyVm>> GetAllList(string Id, int TenantId)
        {
            try
            {
                List<GetCompanyVm> companyDetail = await (from a in _dbContext.CrmCompany.Where(a => a.TenantId == TenantId && a.IsDeleted == 0)
                                                          join b in _dbContext.CrmIndustry on a.IndustryId equals b.IndustryId into all
                                                          from bb in all.DefaultIfEmpty()
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
                                                              IndustryTitle = bb.IndustryTitle,
                                                              CreatedDate = a.CreatedDate
                                                          }).OrderByDescending(a => a.CompanyId).ToListAsync();
                return companyDetail;
            }
            catch (Exception e)
            {
                throw new BadRequestException(e.Message);
            }

        }

        public async Task SaveCompany(string Id, int TenantId, SaveCompanyDto Company)

        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                if (Company.CompanyId != -1)
                {
                    CrmCompany comp = await (from a in _dbContext.CrmCompany.Where(a => a.CompanyId == Company.CompanyId)
                                             select a).FirstAsync();
                    if (comp == null)
                    {
                        throw new NotFoundException(Company.Name, Company.CompanyId);
                    }
                    else
                    {
                        comp.Name = Company.Name;
                        comp.Website = Company.Website;
                        comp.CompanyOwner = Company.CompanyOwner;
                        comp.Mobile = Company.Mobile;
                        comp.Work = Company.Work;
                        comp.BillingAddress = Company.BillingAddress;
                        comp.BillingStreet = Company.BillingStreet;
                        comp.BillingCity = Company.BillingCity;
                        comp.BillingZip = Company.BillingZip;
                        comp.BillingState = Company.BillingState;
                        comp.BillingCountry = Company.BillingCountry;
                        comp.DeliveryAddress = Company.DeliveryAddress;
                        comp.DeliveryStreet = Company.DeliveryStreet;
                        comp.DeliveryCity = Company.DeliveryCity;
                        comp.DeliveryZip = Company.DeliveryZip;
                        comp.DeliveryState = Company.DeliveryState;
                        comp.DeliveryCountry = Company.DeliveryCountry;
                        comp.IndustryId = Company.IndustryId;
                        comp.LastModifiedBy = Id;
                        comp.LastModifiedDate = localDateTime.ToUniversalTime();
                        await _dbContext.SaveChangesAsync();
                    }
                }
                else
                {
                    CrmCompany comp = new CrmCompany();
                    comp.Name = Company.Name;
                    comp.Website = Company.Website;
                    comp.CompanyOwner = Company.CompanyOwner;
                    comp.Mobile = Company.Mobile;
                    comp.Work = Company.Work;
                    comp.BillingAddress = Company.BillingAddress;
                    comp.BillingStreet = Company.BillingStreet;
                    comp.BillingCity = Company.BillingCity;
                    comp.BillingZip = Company.BillingZip;
                    comp.BillingState = Company.BillingState;
                    comp.BillingCountry = Company.BillingCountry;
                    comp.DeliveryAddress = Company.DeliveryAddress;
                    comp.DeliveryStreet = Company.DeliveryStreet;
                    comp.DeliveryCity = Company.DeliveryCity;
                    comp.DeliveryZip = Company.DeliveryZip;
                    comp.DeliveryState = Company.DeliveryState;
                    comp.DeliveryCountry = Company.DeliveryCountry;
                    comp.IndustryId = Company.IndustryId;
                    comp.CreatedBy = Id;
                    comp.CreatedDate = localDateTime.ToUniversalTime();
                    comp.IsDeleted = 0;
                    comp.TenantId = TenantId;
                    await _dbContext.AddAsync(comp);
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception e)
            {
                throw new BadRequestException(e.Message);
            }
        }
    }
}
