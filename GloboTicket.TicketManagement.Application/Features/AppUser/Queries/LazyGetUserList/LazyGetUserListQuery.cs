using ERPCubes.Domain.Common;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.AppUser.Queries.LazyGetUserList
{
    public class LazyGetUserListQuery : Pagination, IRequest<LazyGetUserListVm>
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = String.Empty;
    }
}
