using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Dashboard.Commands.SaveDashboardWidgets
{
    public class SaveDashboardWidgetsCommand : IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; }
        public int DashboardId { get; set; }
        public string Widgets { get; set; } = string.Empty;

    }
}
