using ERPCubes.Application.Features.Crm.Company.Commands.SaveCompany;
using ERPCubes.Application.Features.Crm.Lead.Commands.BulkSaveLead;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadByMonth;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadList;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetleadPiplineReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSource;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadStatus;
using ERPCubes.Application.Features.Tags.Queries.GetTagsList;
using ERPCubes.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncLeadRepository:IAsyncRepository<CrmLead>
    {
        Task<List<GetLeadVm>> GetAllLeads(int TenantId, string Id
            //, DateTime? CreatedDate, DateTime? ModifiedDate, string? LeadOwner, string? LeadStatus
            );
        Task<List<GetLeadStatusListVm>> GetAllLeadStatus(int TenantId, string Id);
        Task<List<GetLeadSourceListVm>> GetAllLeadSource(int TenantId, string Id);
        Task<List<GetLeadReportVm>> GetLeadReport(int TenantId, string Id, DateTime startDate, DateTime endDate, int prodId);
        Task DeleteLead(string Id, int TenantId, int LeadId, string Name);
        Task SaveLead(string Id, int TenantId, SaveLeadDto Lead);
        Task<List<GetLeadByMonthListVm>> GetLeadByMonth(int TenantId, string Id);
        Task SaveLeadBulk(SaveBulkLeadCommand request);
        Task<List<GetleadPiplineReportVm>> GetleadPiplineReport(GetleadPiplineReportQuery obj);
    }
}
