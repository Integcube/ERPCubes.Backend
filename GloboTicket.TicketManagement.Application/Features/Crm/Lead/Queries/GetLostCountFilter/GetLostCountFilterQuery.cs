using ERPCubes.Application.Features.Crm.Lead.Queries.GetNewCountFilter;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLostCountFilter
{
    public class GetLostCountFilterQuery : IRequest<GetLostCountFilterVm>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public int daysAgo { get; set; }
    }
}
