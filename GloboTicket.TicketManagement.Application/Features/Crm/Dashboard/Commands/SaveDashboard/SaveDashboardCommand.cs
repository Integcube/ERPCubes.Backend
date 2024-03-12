using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead;
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
        public int TenantId { get; set; }
        public string Id { get; set; }
        public SaveDashboardDto Dashboard { get; set; } = new SaveDashboardDto();
    }
}
