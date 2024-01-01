using ERPCubes.Application.Features.Crm.Company.Commands.SaveCompany;
using ERPCubes.Application.Features.Crm.Reports.Queries.GetCampaigWiseReport;
using ERPCubes.Application.Features.Tags.Queries.GetTagsList;
using ERPCubes.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncReportsRepository : IAsyncRepository<CrmLead>
    {
        Task<List<GetCampaigWiseReportQueryVm>> GetCampaigWiseReport(GetCampaigWiseReportQuery obj);
    }
}
