using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadOwnerWiseReport
{
    public class GetLeadOwnerWiseQuery : IRequest<List<GetLeadOwnerWiseVm>>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public DateTime startDate { get; set; }
        public DateTime endDate { get; set; }
        public int sourceId { get; set; }
        public string leadOwner { get; set; } = string.Empty;
        public int status { get; set; }
    }
}
