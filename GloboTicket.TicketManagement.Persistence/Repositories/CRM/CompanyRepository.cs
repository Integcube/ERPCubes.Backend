using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Company.Commands.BulkAssignCompany;
using ERPCubes.Application.Features.Crm.Company.Commands.DeleteBulkCompany;
using ERPCubes.Application.Features.Crm.Company.Commands.DeleteCompany;
using ERPCubes.Application.Features.Crm.Company.Commands.RestoreBulkCompany;
using ERPCubes.Application.Features.Crm.Company.Commands.RestoreCompany;
using ERPCubes.Application.Features.Crm.Company.Commands.SaveCompany;
using ERPCubes.Application.Features.Crm.Company.Queries.GetCompanyList;
using ERPCubes.Application.Features.Crm.Company.Queries.GetDeletedCompanyList;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Npgsql;
using System.Linq.Expressions;
using System.Text;
using System.Xml.Linq;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class CompanyRepository : BaseRepository<CrmCompany>, IAsyncCompanyRepository
    {

        public CompanyRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity) { }

        public async Task BulkAssignCompany(BulkAssignCompanyCommand oj)
        {
            var companyIds = string.Join(", ", Enumerable.Range(0, oj.Companies.Count).Select(i => $"@CompanyId{i}"));

            var updateSqlBuilder = new StringBuilder();
            updateSqlBuilder.Append("UPDATE \"CrmCompany\" ");
            updateSqlBuilder.Append("SET \"LastModifiedBy\" = @LastModifiedBy, ");
            updateSqlBuilder.Append("\"LastModifiedDate\" = @LastModifiedDate, ");
            updateSqlBuilder.Append("\"CompanyOwner\" = @CompanyOwner ");
            updateSqlBuilder.Append("WHERE \"CompanyId\" IN (");
            updateSqlBuilder.Append(companyIds);
            updateSqlBuilder.Append(") AND \"TenantId\" = @TenantId");
            var updateSql = updateSqlBuilder.ToString();
            var parameters = new List<NpgsqlParameter>();
            for (int i = 0; i < oj.Companies.Count; i++)
            {
                parameters.Add(new NpgsqlParameter($"@CompanyId{i}", oj.Companies[i].CompanyId));
            }
            parameters.Add(new NpgsqlParameter("@LastModifiedBy", oj.userId));
            parameters.Add(new NpgsqlParameter("@LastModifiedDate", DateTime.Now.ToUniversalTime()));
            parameters.Add(new NpgsqlParameter("@CompanyOwner", oj.CompanyOwner));
            parameters.Add(new NpgsqlParameter("@TenantId", oj.TenantId));
            await _dbContext.Database.ExecuteSqlRawAsync(updateSql, parameters.ToArray());
        }

        public async Task DeleteBulkCompany(DeleteBulkCompanyCommand companyIdss)
        {
            try
            {
                var companyIds = string.Join(", ", Enumerable.Range(0, companyIdss.Companies.Count).Select(i => $"@CompanyId{i}"));

                var updateSqlBuilder = new StringBuilder();
                updateSqlBuilder.Append("UPDATE \"CrmCompany\" ");
                updateSqlBuilder.Append("SET \"DeletedBy\" = @DeletedBy, ");
                updateSqlBuilder.Append("\"DeletedDate\" = @DeletedDate, ");
                updateSqlBuilder.Append("\"IsDeleted\" = @IsDeleted ");
                updateSqlBuilder.Append("WHERE \"CompanyId\" IN (");
                updateSqlBuilder.Append(companyIds);
                updateSqlBuilder.Append(") AND \"TenantId\" = @TenantId");

                var updateSql = updateSqlBuilder.ToString();


                var parameters = new List<NpgsqlParameter>();
                for (int i = 0; i < companyIdss.Companies.Count; i++)
                {
                    parameters.Add(new NpgsqlParameter($"@CompanyId{i}", companyIdss.Companies[i].CompanyId));
                }


                parameters.Add(new NpgsqlParameter("@DeletedBy", companyIdss.Id));
                parameters.Add(new NpgsqlParameter("@DeletedDate", DateTime.Now.ToUniversalTime()));
                parameters.Add(new NpgsqlParameter("@IsDeleted", 1));
                parameters.Add(new NpgsqlParameter("@TenantId", companyIdss.TenantId));

                await _dbContext.Database.ExecuteSqlRawAsync(updateSql, parameters.ToArray());
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task DeleteCompany(DeleteCompanyCommand companyId)
        {
            try
            {
                var deleteCompany = await (from a in _dbContext.CrmCompany.Where(a => a.CompanyId == companyId.CompanyId)
                                           select a).FirstOrDefaultAsync();
                if (deleteCompany == null)
                {
                    throw new NotFoundException("companyId", companyId);
                }
                else
                {
                    deleteCompany.IsDeleted = 1;
                    deleteCompany.DeletedBy = companyId.Id;
                    deleteCompany.DeletedDate = DateTime.Now.ToUniversalTime();
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
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
                                                              Email = a.Email,
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

        public async Task<List<GetDeletedCompanyVm>> GetDeletedCompanies(int TenantId, string Id)
        {
            try
            {
                List<GetDeletedCompanyVm> companyDetail = await(from a in _dbContext.CrmCompany.Where(a => a.TenantId == TenantId && a.IsDeleted == 1)
                                                                join user in _dbContext.AppUser on a.DeletedBy equals user.Id
                                                                select new GetDeletedCompanyVm
                                                                {
                                                                    Id = a.CompanyId,
                                                                    Title = a.Name,
                                                                    DeletedBy = user.FirstName + " " + user.LastName,
                                                                    DeletedDate = a.DeletedDate,
                                                                }).OrderBy(a => a.Title).ToListAsync();
                return companyDetail;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task RestoreBulkCompany(RestoreBulkCompanyCommand command)
        {
            try
            {
                foreach (var companyId in command.CompanyId)
                {
                    var company = await _dbContext.CrmCompany
                        .Where(p => p.CompanyId == companyId && p.IsDeleted == 1)
                        .FirstOrDefaultAsync();

                    if (company == null)
                    {
                        throw new NotFoundException(nameof(companyId), companyId);
                    }

                    company.IsDeleted = 0;
                }

                await _dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task RestoreCompany(RestoreCompanyCommand companyId)
        {
            try
            {
                var restoreProduct = await(from a in _dbContext.CrmCompany.Where(a => a.CompanyId == companyId.CompanyId)
                                           select a).FirstOrDefaultAsync();
                if (restoreProduct == null)
                {
                    throw new NotFoundException("companyId", companyId);
                }
                else
                {
                    restoreProduct.IsDeleted = 0;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
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
