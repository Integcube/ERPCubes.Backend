using ERPCubes.Application.Features.Company.GetCompanyList.Queries;
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

    }

}
