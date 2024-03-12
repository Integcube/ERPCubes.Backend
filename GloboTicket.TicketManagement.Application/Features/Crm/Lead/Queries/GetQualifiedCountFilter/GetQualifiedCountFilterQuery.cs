using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetQualifiedCountFilter
{
    public class GetQualifiedCountFilterQuery : IRequest<GetQualifiedCountFilterVm>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public int daysAgo { get; set; }
    }
}
