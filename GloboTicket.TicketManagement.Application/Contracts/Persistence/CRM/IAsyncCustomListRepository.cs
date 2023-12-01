using ERPCubes.Application.Features.Crm.CustomLists.Commands.DeleteCustomList;
using ERPCubes.Application.Features.Crm.CustomLists.Commands.SaveCustomList;
using ERPCubes.Application.Features.Crm.CustomLists.Commands.SaveCustomListFilters;
using ERPCubes.Application.Features.Crm.CustomLists.Queries.GetCustomLists;
using ERPCubes.Domain.Entities;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncCustomListRepository
    {
        Task<List<GetCustomListVm>> GetAllCustomLists(int TenantId, string Id, string Type);
        Task DeleteCustomList(DeleteCustomListCommand request);
        Task<CrmCustomLists> SaveCustomList (SaveCustomListCommand request);
        Task UpdateCustomListFilter(SaveCustomListFilterCommand request);

    }
}
