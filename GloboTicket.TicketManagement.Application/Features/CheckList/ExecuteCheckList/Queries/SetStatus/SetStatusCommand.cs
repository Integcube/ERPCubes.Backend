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
        public int CPId { get; set; }
        public int TenantId { get; set; }
        public string Id { get; set; }
        public int StatusId { get; set; }

    }
}
