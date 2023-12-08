using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Notes.Queries.GetNotesWithTasks
{
    public class GetNotesTaskDto
    {
        public bool IsCompleted { get; set; }
        public int TaskId { get; set; }
        public string TaskTitle { get; set; }=string.Empty;
    }
}
