using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Commands.ChangeOpportunityStatus
{
    public class ChangeOpportunityStatusCommand : IRequest
    {
        public int TenantId { get; set; }
        public string UserId { get; set; }
        public int OpportunityId { get; set; }
        public int StatusId { get; set; }
        public string StausTitle { get; set; } 

    }
}
