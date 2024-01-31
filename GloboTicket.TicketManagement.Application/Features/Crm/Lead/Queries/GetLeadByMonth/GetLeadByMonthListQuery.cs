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
        public int ProductId { get; set; }
        public int SourceId { get; set; }
        public string UserId { get; set; } = string.Empty;
        public string Year { get; set; } = string.Empty;
    }
}
