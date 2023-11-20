using ERPCubes.Application.Features.Notes.Queries.GetNoteTask;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Notes.Queries.GetNoteTasks
{
    public class GetTaskListQuery:IRequest<List<NoteTaskListVm>>
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = String.Empty;
        public int NoteId { get; set; }
    }
}
