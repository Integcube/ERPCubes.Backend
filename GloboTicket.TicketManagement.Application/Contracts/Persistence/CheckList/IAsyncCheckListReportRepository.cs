using ERPCubes.Application.Features.CheckList.ChecklistReports.Queries.ExecutedLeadChecklistReport;
using ERPCubes.Application.Features.Crm.Checklist.Queries.CheckListReport;

namespace ERPCubes.Application.Contracts.Persistence.CheckList
{
    public interface IAsyncCheckListReportRepository
    {
        Task<List<CheckListReportVm>> CheckListReport(CheckListReportQuery request);
        Task<List<ExecutedLeadChecklistReportVm>> ExecutedLeadCheckListReport(int TenantId, DateTime startDate, DateTime endDate);

    }
}
