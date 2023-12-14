using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ERPCubes.Application.Features.Notes.Commands.DeleteNote
{
    public class DeleteNoteCommand: IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = String.Empty;
        public int NoteId { get; set; }
    }
}
