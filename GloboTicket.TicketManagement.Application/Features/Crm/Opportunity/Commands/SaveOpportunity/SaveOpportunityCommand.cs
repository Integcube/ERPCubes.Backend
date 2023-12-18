using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Commands.SaveOpportunity
{
    public class SaveOpportunityCommand: IRequest
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public int OpportunityId { get; set; }
        public string OpportunityTitle { get; set; } = string.Empty;
        public int OpportunitySource {  get; set; }
        public string? OpportunityDetail { get; set; } = string.Empty;
    }
}
