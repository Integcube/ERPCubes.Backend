using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadStatus;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadByMonth
{
    public class GetLeadByMonthListVm
    {
        public int LeadStatusId { get; set; }
        public string LeadStatusTitle { get; set; }
        public int Count { get; set; }
        public int Month { get; set; }
        public string MonthName { get; set; }
        
    }
}
