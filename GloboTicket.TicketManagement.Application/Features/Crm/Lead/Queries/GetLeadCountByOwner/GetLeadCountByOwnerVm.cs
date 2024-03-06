using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountByOwner
{
    public class GetLeadCountByOwnerVm
    {
        public string LeadOwnerName { get; set; }
        public string LeadOwner { get; set; }
        public int TotalLeads { get; set; }
    }
}
