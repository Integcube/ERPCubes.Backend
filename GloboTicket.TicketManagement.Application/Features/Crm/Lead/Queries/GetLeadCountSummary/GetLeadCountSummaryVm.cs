using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountSummary
{
    public class GetLeadCountSummaryVm
    {
        public int TotalLeads { get; set; }
        public int TotalNewLeads { get; set; }
        public int TotalQualifiedLeads { get; set; }
        public int TotalLostLeads { get; set; }
        public int TotalWonLeads { get; set; }

    }
}
