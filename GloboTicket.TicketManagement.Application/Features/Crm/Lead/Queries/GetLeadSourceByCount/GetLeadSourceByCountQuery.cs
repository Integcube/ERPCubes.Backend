using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountByMonth;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSourceByCount
{
    public class GetLeadSourceByCountQuery : IRequest<List<GetLeadSourceByCountVm>>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
