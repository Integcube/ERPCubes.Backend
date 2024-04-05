using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.ChecklistReports.Queries.ExecutedLeadChecklistReport
{
    public class ExecutedLeadChecklistReportVm
    {
        public int LeadId { get; set; }
        public string FirstName { get; set; }
        public int ExecutedCheckpoints { get; set; }
        public int NotExecutedCheckpoints { get; set; }
        public int ExecutedPercentage { get; set; }
        public int OverdueCheckpoints { get; set; }
        public int TotalCheckpoints { get; set; }
        
    }
}
