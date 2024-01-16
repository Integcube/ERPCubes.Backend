using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadReport
{
    public class GetLeadReportVm
    {
        public int leadStatusId { get; set; } 
        public string LeadStatusTitle { get; set; } 
        public string LeadOwner { get; set; }
        public string FirstName { get; set; } 
        public int ProductId { get; set; }
        public int Count { get; set; }
        public string ProductName { get; set; }

    }
}
