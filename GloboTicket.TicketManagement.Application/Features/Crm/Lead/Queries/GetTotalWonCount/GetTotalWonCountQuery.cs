using ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalLostCount;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalWonCount
{
    public class GetTotalWonCountQuery : IRequest<GetTotalWonCountVm>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
