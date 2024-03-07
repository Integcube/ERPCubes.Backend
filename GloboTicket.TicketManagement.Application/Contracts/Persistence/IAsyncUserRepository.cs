using ERPCubes.Application.Features.AppUser.Commands.BulkRestoreUser;
using ERPCubes.Application.Features.AppUser.Commands.DeleteUser;
using ERPCubes.Application.Features.AppUser.Commands.RestoreUser;
using ERPCubes.Application.Features.AppUser.Commands.UpdateUser;
using ERPCubes.Application.Features.AppUser.Queries.GetDeletedUserList;
using ERPCubes.Application.Features.AppUser.Queries.LazyGetUserList;
using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Application.Features.Crm.Product.Commands.BulkRestoreProduct;
using ERPCubes.Application.Features.Crm.Product.Commands.RestoreProduct;
using ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence
{
    public interface IAsyncUserRepository:IAsyncRepository<GetUserListVm>
    {
        Task<LazyGetUserListVm> LazyGetUserList(LazyGetUserListQuery request);
        Task<List<GetUserListVm>> GetUserList(GetUserListQuery request);
        Task UpdateUser(UpdateUserCommand updateUser);
        Task DeleteUser(DeleteUserCommand cm);
        Task<List<GetDeletedUserListVm>> GetDeletedUsers(int TenantId, string Id);
        Task RestoreUser(RestoreUserCommand user);
        Task RestoreBulkUser(RestoreBulkUserCommand user);
    }
}
