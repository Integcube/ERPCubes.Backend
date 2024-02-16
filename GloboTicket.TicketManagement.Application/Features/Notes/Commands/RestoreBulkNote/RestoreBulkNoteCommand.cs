using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Notes.Commands.RestoreBulkNote
{
    public class RestoreBulkNoteCommand : IRequest
    {
        public List<int> NoteId { get; set; }
    }
}
