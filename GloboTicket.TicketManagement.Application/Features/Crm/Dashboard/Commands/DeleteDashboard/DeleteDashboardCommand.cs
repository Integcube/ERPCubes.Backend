using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Dashboard.Commands.DeleteDashboard
{
    public class DeleteDashboardCommand : IRequest
    {
        public int DashboardId { get; set; }
        public string Id { get; set; } = String.Empty;
    }
}
