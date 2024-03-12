using ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalLeadCount;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalCountFilter
{
    public class GetTotalCountFilterQuery : IRequest<GetTotalCountFilterVm>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public int daysAgo { get; set; }
    }
}
