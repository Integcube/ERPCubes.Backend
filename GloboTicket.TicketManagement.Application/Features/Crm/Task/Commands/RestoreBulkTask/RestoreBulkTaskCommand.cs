using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Commands.RestoreBulkTask
{
    public class RestoreBulkTaskCommand : IRequest
    {
        public List<int> TaskId { get; set; }

    }
}
