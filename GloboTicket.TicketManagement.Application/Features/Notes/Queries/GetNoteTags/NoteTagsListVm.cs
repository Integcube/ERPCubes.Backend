namespace ERPCubes.Application.Features.Notes.Queries.GetNoteTags
{
    public class NoteTagListVm
    {
        public int NoteTagId { get; set; }
        public int TagId { get; set; }
        public int NoteId { get; set; }
        public Boolean IsSelected { get; set; }
        public string TagTitle { get; set; } = String.Empty;
    }
}
