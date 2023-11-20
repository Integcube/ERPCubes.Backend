﻿


using ERPCubes.Application.Features.Notes.Queries.GetNoteList;
using ERPCubes.Application.Features.Notes.Queries.GetNoteTags;
using ERPCubes.Application.Features.Notes.Queries.GetNoteTask;
using ERPCubes.Domain.Entities;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncNoteRepository:IAsyncRepository<CrmNote>
    {
        Task<List<GetNoteListVm>> GetNoteList(int TenantId, string Id, int LeadId, int CompanyId);
        Task<List<NoteTaskListVm>> GetNoteTaskList(int TenantId, string Id, int NoteId);
        Task<List<NoteTagListVm>> GetNoteTagList(int TenantId, string Id, int NoteId);

    }
}
