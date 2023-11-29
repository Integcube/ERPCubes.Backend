using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadList
{
    public class GetLeadListQuery : IRequest<List<GetLeadVm>>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public string? LeadOwner { get; set; } = String.Empty;
        public DateTime? CreatedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public string? LeadStatus { get; set; } = String.Empty;
    }
}
