using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadReport
{
    public class GetLeadReportVm
    {
        public string LeadOwnerId { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public int SId { get; set; }
        public string ProdName { get; set; } = string.Empty;
        public int ProdId { get; set; }
        public int Count { get; set; }
    }
}
