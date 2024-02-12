using ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.AppUser.Queries.GetDeletedUserList
{
    public class GetDeletedUserListQuery : IRequest<List<GetDeletedUserListVm>>
    {
        public string Id { get; set; } = String.Empty;
        public int TenantId { get; set; }
    }
}
