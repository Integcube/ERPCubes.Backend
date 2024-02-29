using ERPCubes.Application.Features.Crm.Lead.Commands.DeleteBulkLeads;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.BulkAssignLeads
{
    public class BulkAssignLeadsCommand : IRequest
    {
        public int TenantId { get; set; }
        public string userId { get; set; }
        public string LeadOwner { get; set; }
        public List<LeadIdsvm> Leads { get; set; }
    }
  
}
