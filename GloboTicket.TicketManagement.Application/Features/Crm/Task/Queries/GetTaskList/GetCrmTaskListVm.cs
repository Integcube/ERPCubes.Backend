using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Queries.GetTaskList
{
    public class GetCrmTaskListVm
    {
        public int TaskId { get; set; }
        public string TaskTitle { get; set; } = string.Empty;
        public DateTime? DueDate { get; set; }
        public int Priority { get; set; }
        public int Status { get; set; }
        public string StatusTitle { get; set; }
        public string? Description { get; set; } = string.Empty;
        public string TaskOwner { get; set; } = string.Empty;
        public string CreatedBy { get; set; } = string.Empty;
        public DateTime CreatedDate { get; set; }
        public string TaskType { get; set; } = string.Empty;
        public int Order { get; set; }

    }
}
