using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Commands.RestoreTasks
{
    public class RestoreTaskCommand : IRequest
    {
        public int TaskId { get; set; }
    }
}
