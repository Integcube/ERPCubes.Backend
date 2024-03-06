using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Dashboard.Queries.GetDashboards
{
    public class GetDashboardQuery : IRequest<List<GetDashboardVm>>
    {
        public string Id { get; set; } = String.Empty;
        public int TenantId { get; set; }
    }
}
