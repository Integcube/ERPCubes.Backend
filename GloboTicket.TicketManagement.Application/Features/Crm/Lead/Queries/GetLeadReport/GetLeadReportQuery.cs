using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadReport
{
    public class GetLeadReportQuery:IRequest<List<GetLeadReportVm>>
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = string.Empty;
        public DateTime startDate {  get; set; }
        public DateTime endDate { get; set; }
        public int prodId {  get; set; }
    }
}
