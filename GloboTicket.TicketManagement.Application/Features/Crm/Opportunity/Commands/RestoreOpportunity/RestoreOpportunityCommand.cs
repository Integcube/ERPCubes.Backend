using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Commands.RestoreOpportunity
{
    public class RestoreOpportunityCommand:IRequest
    {
        public string Id { get; set; }
        public int OpportunityId { get; set; }
    }
}
