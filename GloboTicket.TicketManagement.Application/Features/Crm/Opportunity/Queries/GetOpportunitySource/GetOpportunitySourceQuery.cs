using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportuntiySource
{
    public class GetOpportunitySourceQuery: IRequest<List<GetOpportunitySourceVm>>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
