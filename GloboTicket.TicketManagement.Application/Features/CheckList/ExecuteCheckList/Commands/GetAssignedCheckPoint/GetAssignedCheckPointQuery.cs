using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.ExecuteCheckList.Commands.GetAssignedCheckPoint
{
    public class GetAssignedCheckPointQuery:IRequest<List<GetAssignedCheckPointVm>>
    {
        public string UserId { get; set; }
        public int TenantId { get; set; }
        public int ExecId { get; set; }
    }
}
