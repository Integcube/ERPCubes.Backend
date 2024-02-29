using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.ChangeBulkLeadStatus
{
    public class ChangeBulkLeadStatusCommand : IRequest
    {
        public int TenantId { get; set; }
        public string userId { get; set; }
        public int statusId { get; set; }
        public string StausTitle { get; set; }
        public List<Leads> Leads { get; set; }
    }
    public class Leads
    {
        public int LeadId { get; set; }
    }

}
