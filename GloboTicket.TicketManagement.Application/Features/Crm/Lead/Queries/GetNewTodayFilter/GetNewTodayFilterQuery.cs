using ERPCubes.Application.Features.Crm.Lead.Queries.GetLostCountFilter;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetNewTodayFilter
{
    public class GetNewTodayFilterQuery : IRequest<GetNewTodayFilterVm>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
