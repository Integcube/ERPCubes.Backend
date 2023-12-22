using ERPCubes.Application.Features.Crm.Company.Queries.GetCompanyList;
using ERPCubes.Application.Features.Crm.Email.Commands.DeleteEmail;
using ERPCubes.Application.Features.Crm.Email.Commands.SaveEmail;
using ERPCubes.Application.Features.Crm.Email.Queries.GetEmailList;
using ERPCubes.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncEmailRepository : IAsyncRepository<CrmEmail>
    {
        Task<List<GetEmailVm>> GetAllList(string Id, int TenantId, int LeadId, int CompanyId, int Opportunity);
        Task DeleteEmail(DeleteEmailCommand emailId);
        Task SaveEmail(SaveEmailCommand email);
    }
}
