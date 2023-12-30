using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSourceWiseReport
{
    public class GetLeadSourceWiseQuery : IRequest<List<GetLeadSourceWiseVm>>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public DateTime startDate { get; set; }
        public DateTime endDate { get; set; }
        public int sourceId { get; set; }
    }
}
