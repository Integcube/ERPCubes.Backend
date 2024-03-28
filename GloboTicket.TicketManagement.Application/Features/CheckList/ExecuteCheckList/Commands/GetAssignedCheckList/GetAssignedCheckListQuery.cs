using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.ExecuteCheckList.Commands.GetAssignedCheckList
{
    public class GetAssignedCheckListQuery:IRequest<List<GetAssignedCheckListVm>>
    {
        public string Id { get; set; }
        public int TenantId { get; set; }
        public string UserId { get; set; }
    }
}
