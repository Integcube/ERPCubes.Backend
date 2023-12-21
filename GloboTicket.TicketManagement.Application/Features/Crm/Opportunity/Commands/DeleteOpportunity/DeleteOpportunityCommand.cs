using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Commands.DeleteOpportunity
{
    public class DeleteOpportunityCommand : IRequest
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public int OpportunityId { get; set; }
    }
}
