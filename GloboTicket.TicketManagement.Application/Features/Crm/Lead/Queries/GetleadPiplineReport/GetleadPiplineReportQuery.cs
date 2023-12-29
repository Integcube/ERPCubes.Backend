using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetleadPiplineReport
{
    public class GetleadPiplineReportQuery : IRequest<List<GetleadPiplineReportVm>>
    {
        public int TenantId { get; set; }
        public int SourceId { get; set; }
        public int Status { get; set; }
        public int ProductId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string LeadOwner { get; set; } = string.Empty;

    }
}
