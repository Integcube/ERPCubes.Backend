using ERPCubes.Application.Features.Crm.Company.Commands.DeleteCompany;
using ERPCubes.Application.Features.Crm.Company.Commands.RestoreBulkCompany;
using ERPCubes.Application.Features.Crm.Company.Commands.RestoreCompany;
using ERPCubes.Application.Features.Crm.Company.Commands.SaveCompany;
using ERPCubes.Application.Features.Crm.Company.Queries.GetCompanyList;
using ERPCubes.Application.Features.Crm.Company.Queries.GetDeletedCompanyList;
using ERPCubes.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncCompanyRepository: IAsyncRepository<CrmCompany>
    {
        Task<List<GetCompanyVm>> GetAllList(string Id, int TenantId);
        Task DeleteCompany(DeleteCompanyCommand product);
        Task SaveCompany(string Id, int TenantId, SaveCompanyDto Company);
        Task<List<GetDeletedCompanyVm>> GetDeletedCompanies(int TenantId, string Id);
        Task RestoreCompany(RestoreCompanyCommand companyId);
        Task RestoreBulkCompany(RestoreBulkCompanyCommand companyId);
    }

}
