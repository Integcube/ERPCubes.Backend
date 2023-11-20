namespace ERPCubes.Application.Features.Notes.Queries.GetNoteTask
{
    public class NoteTaskListVm
    {
        public int TaskId { get; set; }
        public string Task { get; set; }=String.Empty;
        public int NoteId { get; set; }
        public Boolean IsCompleted { get; set; }

    }
}
