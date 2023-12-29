using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetleadPiplineReport
{
    public class GetleadPiplineReportVm
    {
        public int Status { get; set; }
        public string StatusTitle { get; set; } = string.Empty;
        public int TotalLeads { get; set; }
        public decimal TotalLeadValue { get; set; }
        public decimal AverageDealValue { get; set; }
        public int WinLeads { get; set; }
        public decimal WinRate { get; set; }
        public int ConvertedLeads { get; set; }
        public decimal ConversionRate { get; set; }
        public decimal ExpectedRevenue { get; set; }
    }
}
