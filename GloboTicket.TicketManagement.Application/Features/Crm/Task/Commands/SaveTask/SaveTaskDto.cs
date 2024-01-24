using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Commands.SaveTask
{
    public class SaveTaskDto
    {
        public int TaskId { get; set; }
        public string TaskTitle { get; set; }=String.Empty;
        public string Description { get; set; } = String.Empty;
        public int? PriorityId { get; set; }
        public int? StatusId { get; set; }
        public string TaskOwner { get; set; } = String.Empty;
        public string Tags { get; set; }=string.Empty;
        public DateTime? DueDate { get; set; }
        public string Type { get; set; } = string.Empty;
        public int ContactTypeId { get; set; }
        public int ContactId { get; set; }
        public int TaskTypeId { get; set; }

    }
}
