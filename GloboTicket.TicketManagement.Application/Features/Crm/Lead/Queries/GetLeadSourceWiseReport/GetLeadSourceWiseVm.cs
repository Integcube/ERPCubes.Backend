using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSourceWiseReport
{
    public class GetLeadSourceWiseVm
    {
        public int SourceId { get; set; }
        public string Source { get; set; } = string.Empty;
        public int TotalLeads { get; set; }
        public int ConvertedLeads { get; set; }
        public decimal ConversionRate { get; set; }
        public decimal AverageDealSize { get; set; }
        public decimal TotalRevenue { get; set; }
    }
}
