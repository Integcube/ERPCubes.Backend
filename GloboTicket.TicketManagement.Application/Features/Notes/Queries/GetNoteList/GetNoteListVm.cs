using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Notes.Queries.GetNoteList
{
    public class GetNoteListVm
    {
        public int NoteId { get; set; }
        public string Content { get; set; } = string.Empty;
        public string NoteTitle { get; set; } = string.Empty;
        public DateTime CreatedDate { get; set; }
        public string CreatedBy { get; set; } = string.Empty;
    }
}
