using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportuntiySource
{
    public class GetOpportunitySourceVm
    {
        public int SourceId { get; set; }
        public string SourceTitle { get; set; } = string.Empty;
    }
}
