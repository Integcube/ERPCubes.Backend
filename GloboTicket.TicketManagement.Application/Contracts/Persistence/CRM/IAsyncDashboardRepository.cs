using ERPCubes.Application.Features.Crm.Dashboard.Commands.DeleteDashboard;
using ERPCubes.Application.Features.Crm.Dashboard.Commands.SaveDashboard;
using ERPCubes.Application.Features.Crm.Dashboard.Queries.GetDashboards;
using ERPCubes.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncDashboardRepository : IAsyncRepository<CrmDashboard>
    {
        Task<List<GetDashboardVm>> GetAllDashboard(int TenantId, string Id);
        Task SaveDashboard(SaveDashboardCommand dashboard);
        Task DeleteDashboard(DeleteDashboardCommand dashboard);


    }
}
