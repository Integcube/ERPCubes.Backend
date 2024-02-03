using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Activity.Queries.GetUserActivityReport
{
    public class GetUserActivityReportQuery: IRequest<List<GetUserActivityReportVm>>
    {
        public string Id {  get; set; } = string.Empty;
        public int TenantId { get; set; }
        public int ProjectId { get; set; }
        public int Status { get; set; }
        public int ProductId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

    }
}
