using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunity
{
    public class GetOpportunityQuery: IRequest<List<GetOpportunityVm>>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId {  get; set; }
    }
}
