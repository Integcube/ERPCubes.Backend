using ERPCubes.Domain.Common;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.LazyGetAssignCheckList
{
    public class LazyGetAssignCheckListQuery : Pagination, IRequest<LazyGetAssignCheckListVm>
    {
        public int TenantId { get; set; }
        public string Id { get; set; } 
    }
}
