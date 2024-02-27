using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Commands.RestoreBulkOpportunity
{
    public class RestoreBulkOpportunityCommand : IRequest
    {
        public List<int> OpportunityId { get; set; }

    }
}
