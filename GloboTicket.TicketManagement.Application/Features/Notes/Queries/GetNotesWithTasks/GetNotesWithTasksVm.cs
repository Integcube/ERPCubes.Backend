using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Notes.Queries.GetNotesWithTasks
{
    public class GetNotesWithTasksVm
    {
        public int NoteId { get; set; }
        public string Content { get; set; } = string.Empty;
        public string NoteTitle { get; set; } = string.Empty;
        public DateTime CreatedDate { get; set; }
        public List<GetNotesTagsDto>? Tags { get; set; }
        public List<GetNotesTaskDto>? Tasks { get; set; }
    }
}
