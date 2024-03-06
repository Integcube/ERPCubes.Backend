using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountByMonth;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalLeadCount
{
    public class GetTotalLeadCountQuery : IRequest<GetTotalLeadCountVm>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
