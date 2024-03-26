using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.ExecuteCheckList.Queries.SetStatus
{
    public class SetStatusCommand:IRequest
    {
        public int ExecId { get; set; }
        public int ChpId { get; set; }
        public int UserId { get; set; }
    }
}
