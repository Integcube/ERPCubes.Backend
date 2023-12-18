using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunity
{
    public class GetOpportunityVm
    {
        public int OpportunityId { get; set; }
        public string OpportunityTitle { get; set; } = string.Empty;
        public int OpportunitySource { get; set; }
        public string? OpportunityDetail { get; set; } = string.Empty;
    }
}
