using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Notes.Commands.RestoreNotes
{
    public class RestoreNoteCommand : IRequest
    {
        public int NoteId { get; set; }
    }
}
