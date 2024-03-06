using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Dashboard.Commands.SaveDashboard
{
    public class SaveDashboardCommand : IRequest
    {
        public int DashboardId { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public int IsPrivate { get; set; }
        public string Widgets { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public string Id { get; set; } = string.Empty;

    }
}
