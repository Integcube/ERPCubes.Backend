using MediatR;

namespace ERPCubes.Application.Features.Notes.Queries.GetNoteTags
{
    public class GetNoteTagListQuery:IRequest<List<NoteTagListVm>>
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = String.Empty;
        public int NoteId { get; set; }
    }
}
