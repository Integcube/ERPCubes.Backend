


using ERPCubes.Application.Features.Notes.Commands.DeleteNote;
using ERPCubes.Application.Features.Notes.Commands.SaveNote;
using ERPCubes.Application.Features.Notes.Queries.GetNoteList;
using ERPCubes.Application.Features.Notes.Queries.GetNotesWithTasks;
using ERPCubes.Application.Features.Notes.Queries.GetNoteTags;
using ERPCubes.Application.Features.Notes.Queries.GetNoteTask;
using ERPCubes.Domain.Entities;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncNoteRepository:IAsyncRepository<CrmNote>
    {
        Task<List<GetNoteListVm>> GetNoteList(int TenantId, string Id, int LeadId, int CompanyId, int OpportunityId);
        Task<List<NoteTaskListVm>> GetNoteTaskList(int TenantId, string Id, int NoteId);
        Task<List<NoteTagListVm>> GetNoteTagList(int TenantId, string Id, int NoteId);
        Task<List<GetNotesWithTasksVm>> GetNoteListWithTasks(int TenantId, string Id);
        Task SaveNote(SaveNoteCommand request);
        Task DeletNote(DeleteNoteCommand request);
    }
}
