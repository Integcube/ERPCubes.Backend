using ERPCubes.Domain.Common;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadList
{
    public class GetLeadListQuery :Pagination , IRequest<GetLeadVm>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public List<string> LeadOwner { get; set; }
        public List<int> LeadStatus { get; set; }
        public DateTime? CreatedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
     
    }
}
