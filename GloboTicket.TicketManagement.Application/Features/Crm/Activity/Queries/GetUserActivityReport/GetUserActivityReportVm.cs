using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Activity.Queries.GetUserActivityReport
{
    public class GetUserActivityReportVm
    {
        public string LeadOwner { get; set; } = string.Empty;
        public int? Lead {  get; set; }
        public int? Note { get; set;}
        public int? Call { get; set; }
        public int? Email { get; set; }
        public int? Task { get; set; }
        public int? Meeting { get; set; }
        public string LeadOwnerName { get; set; }
    }
}
