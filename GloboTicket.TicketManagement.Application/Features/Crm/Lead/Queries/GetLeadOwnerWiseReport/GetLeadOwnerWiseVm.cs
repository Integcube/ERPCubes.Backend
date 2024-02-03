using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadOwnerWiseReport
{
    public class GetLeadOwnerWiseVm
    {
        public string LeadOwner { get; set; } 
        public int TotalLeads { get; set; }
        public decimal TotalRevenue { get; set; }
        public decimal AverageDealSize { get; set; }
        public int WinLeads { get; set; }
        public decimal WinRate { get; set; }
        public int ConvertedLeads { get; set; }
        public decimal ConversionRate { get; set; }
        public string LeadOwnerName { get; set; } 
        
    }
}
