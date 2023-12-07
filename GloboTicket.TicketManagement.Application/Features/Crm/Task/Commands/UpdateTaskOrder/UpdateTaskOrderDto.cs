using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskOrder
{
    public class UpdateTaskOrderDto
    {
        public int TaskId { get; set; }
        public string TaskTitle { get; set; } = String.Empty;
        public string TaskType { get; set; } = String.Empty; // You might want to create an enum for 'task' and 'section'
        public DateTime? DueDate { get; set; }
        public int Priority { get; set; }
        public int Order { get; set; }
        public int Status { get; set; }
        public string StatusTitle { get; set; } = String.Empty;
        public string Description { get; set; } = String.Empty;
        public string TaskOwner { get; set; } = String.Empty;
        public string CreatedBy { get; set; } = String.Empty;
        public DateTime? CreatedDate { get; set; }
    }
}
