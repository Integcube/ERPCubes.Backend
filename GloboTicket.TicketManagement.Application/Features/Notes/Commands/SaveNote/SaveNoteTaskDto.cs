using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Notes.Commands.SaveNote
{
    public class SaveNoteTaskDto
    {
        public string Task { get; set; } = String.Empty;

        public bool IsCompleted { get; set; }
    }
}
