using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead;
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
        public SaveOpportunityDto dto { get; set; } = new SaveOpportunityDto();

    }
}
