using ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalQualifiedCount;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalLostCount
{
    public class GetTotalLostCountQuery : IRequest<GetTotalLostCountVm>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
