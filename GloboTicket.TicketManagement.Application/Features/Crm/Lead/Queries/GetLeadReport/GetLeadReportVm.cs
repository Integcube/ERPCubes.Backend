using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadReport
{
    public class GetLeadReportVm
    {
        public string LeadOwner { get; set; } = string.Empty;
        public string StatusTitle { get; set; } = string.Empty;
        public int StatusId { get; set; }
        public string ProductName { get; set; } = string.Empty;
        public int ProductId { get; set; }
        public int Count { get; set; }
    }
}
