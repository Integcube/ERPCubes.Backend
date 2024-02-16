using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Commands.DeleteTask
{
    public class DeleteTaskCommand:IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; }=String.Empty;
        public string TaskTitle { get; set; } = String.Empty;
        public int TaskId { get; set; }
        public string DeletedBy { get; set; }
        public DateTime? DeletedDate { get; set; }
    }
}
