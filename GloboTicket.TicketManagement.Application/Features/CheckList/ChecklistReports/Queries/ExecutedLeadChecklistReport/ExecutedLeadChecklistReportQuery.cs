using ERPCubes.Application.Features.Crm.Checklist.Queries.CheckListReport;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.ChecklistReports.Queries.ExecutedLeadChecklistReport
{
    public class ExecutedLeadChecklistReportQuery : IRequest<List<ExecutedLeadChecklistReportVm>>
    {
        public string Id { get; set; } = String.Empty;
        public int TenantId { get; set; }
        public DateTime startDate { get; set; }
        public DateTime endDate { get; set; }
    }
}
