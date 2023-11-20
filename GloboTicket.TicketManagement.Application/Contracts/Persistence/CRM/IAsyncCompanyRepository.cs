using ERPCubes.Application.Features.Crm.Company.Commands.SaveCompany;
using ERPCubes.Application.Features.Crm.Company.Queries.GetCompanyList;
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
        Task DeleteCompany(string Id, int TenantId, int CompanyId);
        Task SaveCompany(string Id, int TenantId, SaveCompanyDto Company);
    }

}
