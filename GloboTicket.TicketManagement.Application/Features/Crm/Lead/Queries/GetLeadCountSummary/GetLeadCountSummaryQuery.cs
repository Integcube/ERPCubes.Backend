using ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalWonCount;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountSummary
{
    public class GetLeadCountSummaryQuery : IRequest<GetLeadCountSummaryVm>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
