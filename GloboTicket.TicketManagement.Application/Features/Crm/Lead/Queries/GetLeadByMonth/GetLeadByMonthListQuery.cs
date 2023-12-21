using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadByMonth
{
    public class GetLeadByMonthListQuery : IRequest<List<GetLeadByMonthListVm>>
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = string.Empty;
    }
}
