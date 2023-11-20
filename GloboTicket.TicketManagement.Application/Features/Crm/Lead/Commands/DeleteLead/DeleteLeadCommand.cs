using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.DeleteLead
{
    public class DeleteLeadCommand:IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = String.Empty;
        public int LeadId { get; set; }
        public string Name { get;set; } = String.Empty;
    }
}
