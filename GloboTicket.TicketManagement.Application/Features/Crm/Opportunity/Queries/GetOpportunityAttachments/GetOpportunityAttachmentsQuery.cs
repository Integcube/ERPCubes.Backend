using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadAttachments;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunityAttachments
{
    public class GetOpportunityAttachmentsQuery : IRequest<List<GetOpportunityAttachmentsVm>>
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = string.Empty;
        public int OpportunityId { get; set; }
        public int ContactTypeId { get; set; }
    }
}
