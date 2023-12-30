using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Reports.Queries.GetCampaigWiseReport
{
    public class GetCampaigWiseReportQueryVm
    {
        public string CampaignId { get; set; } = string.Empty;
        public string CampaignTitle { get; set; } = string.Empty;
        public string Source { get; set; } = string.Empty;
        public int TotalLeads { get; set; }
        public int WinLeads { get; set; }
        public decimal WinRate { get; set; }
        public int ConvertedLeads { get; set; }
        public decimal ConversionRate { get; set; }
        public decimal TotalCost { get; set; }
        public decimal CostperLead { get; set; }
        public decimal RevenueGenerated { get; set; }
        public decimal ReturnonInvestment { get; set; }
    }

}
