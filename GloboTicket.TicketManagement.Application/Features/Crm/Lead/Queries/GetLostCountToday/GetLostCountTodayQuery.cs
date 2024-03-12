using ERPCubes.Application.Features.Crm.Lead.Queries.GetLostCountFilter;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLostCountToday
{
    public class GetLostCountTodayQuery : IRequest<GetLostCountTodayVm>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
