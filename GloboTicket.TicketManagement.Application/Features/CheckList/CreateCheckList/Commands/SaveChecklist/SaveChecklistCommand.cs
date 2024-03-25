using ERPCubes.Application.Features.Crm.Dashboard.Commands.SaveDashboard;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Checklist.Command.SaveChecklist
{
    public class SaveChecklistCommand : IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; }
        public SaveChecklistDto Checklist { get; set; } = new SaveChecklistDto();
    }
}
