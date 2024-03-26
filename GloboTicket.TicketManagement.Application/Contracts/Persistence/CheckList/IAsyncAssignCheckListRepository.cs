using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.AssignCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.AssigntToLeadsCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.DeleteAssignCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.LazyGetAssignCheckList;
using ERPCubes.Application.Features.Crm.Email.Commands.SaveEmail;
namespace ERPCubes.Application.Contracts.Persistence.CheckList
{
    public interface IAsyncAssignCheckListRepository 
    {
        Task<LazyGetAssignCheckListVm> LazyGetAssignCheckList(LazyGetAssignCheckListQuery request);
        Task<List<GetCheckListVm>> GetCheckList(GetCheckListQuery request);
        Task<List<GetCheckPointVm>> GetCheckPoint(GetCheckPointQuery request);
        Task AssignCheckList(AssignCheckPointCommand request);
        Task Delete(DeleteAssignCheckPointCommand request);
        Task AssignToLeads(AssigntToLeadsCheckPointCommand request);
        

    }
}
