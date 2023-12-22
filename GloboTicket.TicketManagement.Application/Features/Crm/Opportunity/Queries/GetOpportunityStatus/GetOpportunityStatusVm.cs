using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunityStatus
{
    public class GetOpportunityStatusVm
    {
        public int StatusId { get; set; }
        public string StatusTitle { get; set; } = string.Empty;
        public int IsDeletable { get; set; }
        public int Order { get; set; }
    }
}
