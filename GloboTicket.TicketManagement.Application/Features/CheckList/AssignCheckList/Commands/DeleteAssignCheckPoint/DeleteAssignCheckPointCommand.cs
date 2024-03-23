using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.DeleteAssignCheckPoint
{
    public class DeleteAssignCheckPointCommand : IRequest
    {
        public int ExecId { get; set; }
        public string Id { get; set; }
        public int TenantId { get; set; }
    }
}
