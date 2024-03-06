using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountByOwner;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountByMonth
{
    public class GetLeadCountByMonthQuery : IRequest<List<GetLeadCountByMonthVm>>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
