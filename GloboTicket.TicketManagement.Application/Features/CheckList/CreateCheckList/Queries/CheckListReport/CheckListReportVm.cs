using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Checklist.Queries.CheckListReport
{
    public class CheckListReportVm
    {
        public int ExecId { get; set; }
        public string Referenceno { get; set; }
        public string Title { get; set; }
        public int Total { get; set; } 
        public int ExecutedCount { get; set; }
        public int NotExecutedCount { get; set; } 
        public  decimal ExecutedPercentage { get; set; }
    }
}
