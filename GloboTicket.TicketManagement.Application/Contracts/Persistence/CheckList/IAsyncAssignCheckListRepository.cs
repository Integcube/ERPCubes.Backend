using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.LazyGetAssignCheckList;
namespace ERPCubes.Application.Contracts.Persistence.CheckList
{
    public interface IAsyncAssignCheckListRepository 
    {
        Task<LazyGetAssignCheckListVm> LazyGetAssignCheckList(LazyGetAssignCheckListQuery request);
        Task<List<GetCheckListVm>> GetCheckList(GetCheckListQuery request);
        Task<List<GetCheckPointVm>> GetCheckPoint(GetCheckPointQuery request);
    }
}
