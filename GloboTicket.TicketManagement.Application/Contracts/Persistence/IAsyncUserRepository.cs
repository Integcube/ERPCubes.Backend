using ERPCubes.Application.Features.AppUser.Commands.UpdateUser;
using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence
{
    public interface IAsyncUserRepository:IAsyncRepository<GetUserListVm>
    {
        Task<List<GetUserListVm>> GetUserList(int TenantId, string Id);
        Task UpdateUser(UpdateUserCommand updateUser);

    }
}
