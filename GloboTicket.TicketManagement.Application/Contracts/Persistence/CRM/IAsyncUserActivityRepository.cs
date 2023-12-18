using ERPCubes.Application.Features.Crm.Activity.Queries.GetUserActivityReport;
using ERPCubes.Application.Features.Crm.UserActivity.Queries.GetUserActivity;
using ERPCubes.Domain.Entities;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncUserActivityRepository : IAsyncRepository<CrmUserActivityLog>
    {
        Task<List<GetUserActivityVm>> GetUserActivityListAsync(GetUserActivityQuery request);
        Task<List<GetUserActivityReportVm>> GetUserActivityReport(string Id, int TenantId);
    }
}
