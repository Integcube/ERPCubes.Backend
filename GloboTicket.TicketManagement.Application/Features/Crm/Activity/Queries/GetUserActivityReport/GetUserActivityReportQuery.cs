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
    }
}
