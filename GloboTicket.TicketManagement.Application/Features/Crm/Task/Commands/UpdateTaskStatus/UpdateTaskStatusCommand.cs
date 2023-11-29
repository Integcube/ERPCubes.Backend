using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskStatus
{
    public class UpdateTaskStatusCommand:IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = String.Empty;
        public int TaskId { get; set; }
        public int Status { get; set; }
        public string TaskTitle { get; set; } = String.Empty;
    }
}
