using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Reports.Queries.GetCampaigWiseReport
{

    public class GetCampaigWiseReportQuery : IRequest<List<GetCampaigWiseReportQueryVm>>
    {
        public int TenantId { get; set; }
        public int SourceId { get; set; }
        public string Campaign { get; set; } = string.Empty;
        public int ProductId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
    }
}
