using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Dashboard.Commands.SaveDashboard
{
    public class SaveDashboardDto
    {
        public int DashboardId { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public int IsPrivate { get; set; }
        public string Widgets { get; set; } = string.Empty;

    }
}
