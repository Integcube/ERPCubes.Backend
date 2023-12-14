using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Notes.Commands.SaveNote
{
    public class SaveNoteDto
    {
        public int NoteId { get; set; }
        public string Content { get; set; } = String.Empty;
        public string NoteTitle { get; set; } = String.Empty;
        public string Tags { get; set; } = string.Empty;
        public List<SaveNoteTaskDto>? Tasks { get; set; } = new List<SaveNoteTaskDto>();
    }
}

