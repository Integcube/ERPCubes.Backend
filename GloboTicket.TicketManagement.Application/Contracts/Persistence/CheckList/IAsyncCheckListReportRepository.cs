using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.AssignCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.AssigntToLeadsCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.DeleteAssignCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetExcutedCheckListbyId;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.LazyGetAssignCheckList;
using ERPCubes.Application.Features.Crm.Checklist.Queries.CheckListReport;
using ERPCubes.Application.Features.Crm.Checklist.Queries.GetChecklists;
using ERPCubes.Application.Features.Crm.Email.Commands.SaveEmail;
namespace ERPCubes.Application.Contracts.Persistence.CheckList
{
    public interface IAsyncCheckListReportRepository
    {
        Task<List<CheckListReportVm>> CheckListReport(CheckListReportQuery request);
    }
}
