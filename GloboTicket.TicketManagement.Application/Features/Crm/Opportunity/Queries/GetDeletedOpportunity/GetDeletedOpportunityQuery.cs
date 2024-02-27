using ERPCubes.Application.Features.Crm.Lead.Queries.GetDeletedLeads;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Queries.GetDeletedOpportunity
{
    public class GetDeletedOpportunityQuery: IRequest<List<GetDeletedOpportunityVm>>
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = string.Empty;
    }
}
