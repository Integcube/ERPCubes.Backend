using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList;
using ERPCubes.Application.Features.Notes.Commands.DeleteNote;
using ERPCubes.Application.Features.Notes.Commands.RestoreBulkNote;
using ERPCubes.Application.Features.Notes.Commands.RestoreNotes;
using ERPCubes.Application.Features.Notes.Commands.SaveNote;
using ERPCubes.Application.Features.Notes.Queries.GetDeletedNotes;
using ERPCubes.Application.Features.Notes.Queries.GetNoteList;
using ERPCubes.Application.Features.Notes.Queries.GetNotesWithTasks;
using ERPCubes.Application.Features.Notes.Queries.GetNoteTags;
using ERPCubes.Application.Features.Notes.Queries.GetNoteTask;
using ERPCubes.Application.Models.Mail;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class NoteRepository : BaseRepository<CrmNote>, IAsyncNoteRepository
    {
        public NoteRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task<List<GetNoteListVm>> GetNoteList(int TenantId, string Id, int ContactTypeId, int ContactId)
        {
            try
            {
                List<GetNoteListVm> Notes = await (
                    from a in _dbContext.CrmNote.Where(a => a.IsDeleted == 0
                    && a.TenantId == TenantId
                    && (Id == "-1" || a.CreatedBy == Id)
                    && (a.Id == ContactId)
                    && (a.ContactTypeId == ContactTypeId))
                    join uer in _dbContext.AppUser on a.CreatedBy equals uer.Id into all
                    from user in all.DefaultIfEmpty()
                    select new GetNoteListVm
                    {
                        NoteId = a.NoteId,
                        NoteTitle = a.NoteTitle,
                        Content = a.Content,
                        CreatedBy = a.CreatedBy,
                        CreatedDate = a.CreatedDate,
                        CreatedByName = user == null ? "User Not Found" : user.FirstName + " " + user.LastName,
                    }
                    ).OrderByDescending(a => a.CreatedDate).ToListAsync();

                return Notes;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetNotesWithTasksVm>> GetNoteListWithTasks(int TenantId, string Id)
        {
            try
            {
                var notes = await (from a in _dbContext.CrmNote.Where(a => a.TenantId == TenantId && a.CreatedBy == Id && a.ContactTypeId == -1 && a.IsDeleted == 0)

                                   select new GetNotesWithTasksVm
                                   {
                                       NoteId = a.NoteId,
                                       NoteTitle = a.NoteTitle,
                                       Content = a.Content,
                                       CreatedDate = a.CreatedDate,
                                       Tags = (from b in _dbContext.CrmNoteTags
                                               where a.NoteId == b.NoteId
                                               join t in _dbContext.CrmTags on b.TagId equals t.TagId
                                               select new GetNotesTagsDto
                                               {
                                                   TagId = b.TagId,
                                                   TagTitle = t.TagTitle
                                               }).ToList(),
                                       Tasks = (from c in _dbContext.CrmNoteTasks
                                                where a.NoteId == c.NoteId
                                                select new GetNotesTaskDto
                                                {
                                                    TaskId = c.NoteTaskId,
                                                    TaskTitle = c.Task,
                                                    IsCompleted = c.IsCompleted == 1 ? true : false,
                                                }).ToList(),
                                   }).ToListAsync();

                return notes;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<NoteTagListVm>> GetNoteTagList(int TenantId, string Id, int NoteId)
        {
            try
            {
                List<NoteTagListVm> Tags = await (from a in _dbContext.CrmNoteTags.Where(a => a.TenantId == TenantId && a.NoteId == NoteId)
                                                  join c in _dbContext.CrmTags.Where(a => a.IsDeleted == 0) on a.TagId equals c.TagId
                                                  select new NoteTagListVm
                                                  {
                                                      NoteId = a.NoteId,
                                                      TagId = c.TagId,
                                                      TagTitle = c.TagTitle,
                                                      NoteTagId = a.NoteTagsId,
                                                      IsSelected = a.TagId == null ? false : true,
                                                  }
                                                   ).OrderByDescending(a => a.TagTitle).ToListAsync();

                return Tags;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<NoteTaskListVm>> GetNoteTaskList(int TenantId, string Id, int NoteId)
        {
            try
            {
                List<NoteTaskListVm> Tasks = await (from b in _dbContext.CrmNoteTasks.Where(a => a.IsDeleted == 0 && a.NoteId == NoteId)
                                                    select new NoteTaskListVm
                                                    {
                                                        NoteId = b.NoteId,
                                                        TaskId = b.NoteTaskId,
                                                        Task = b.Task,
                                                        IsCompleted = b.IsCompleted == 0 ? false : true,

                                                    }).OrderByDescending(a => a.TaskId).ToListAsync();

                return Tasks;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task SaveNote(SaveNoteCommand request)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                if (request.Note.NoteId == -1)
                {
                    CrmNote note = new CrmNote();
                    note.NoteTitle = request.Note.NoteTitle;
                    note.Content = request.Note.Content;
                    note.CreatedDate = localDateTime.ToUniversalTime();
                    note.CreatedBy = request.Id;
                    note.TenantId = request.TenantId;
                    note.IsDeleted = 0;
                    note.ContactTypeId = request.ContactTypeId;
                    note.Id = request.ContactId;
                    await _dbContext.AddAsync(note);
                    await _dbContext.SaveChangesAsync();

                    var result = _dbContext.Database.ExecuteSqlRaw(
                    "CALL public.InsertCrmUserActivityLog({0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8},{9})",
                     note.CreatedBy, (int)CrmEnum.UserActivityEnum.Note, 1, note.NoteTitle, note.CreatedBy, note.TenantId, note.ContactTypeId, note.NoteId, "Insertion", note.Id);

                    List<int> TagIds = new List<int>();
                    if (!string.IsNullOrEmpty(request.Note.Tags))
                        TagIds = (request.Note.Tags.Split(',').Select(Int32.Parse).ToList());
                    foreach (var item in TagIds)
                    {
                        CrmNoteTags tags = new CrmNoteTags();
                        tags.NoteId = note.NoteId;
                        tags.TagId = item;
                        tags.CreatedBy = request.Id;
                        tags.CreatedDate = localDateTime.ToUniversalTime();
                        tags.TenantId = request.TenantId;
                        await _dbContext.AddAsync(tags);
                        await _dbContext.SaveChangesAsync();
                    }
                    foreach (var taskDto in request.Note?.Tasks ?? new List<SaveNoteTaskDto>())
                    {

                        var taskEntity = new CrmNoteTasks
                        {
                            NoteId = note.NoteId,
                            CreatedDate = localDateTime.ToUniversalTime(),
                            CreatedBy = request.Id,
                            TenantId = request.TenantId,
                            IsDeleted = 0,
                            Task = taskDto.Task,
                            IsCompleted = taskDto.IsCompleted == true ? 1 : 0
                        };
                        await _dbContext.AddAsync(taskEntity);
                        await _dbContext.SaveChangesAsync();
                    }

                    await _dbContext.SaveChangesAsync();
                }
                else
                {
                    var note = await (from a in _dbContext.CrmNote.Where(a => a.NoteId == request.Note.NoteId)
                                      select a).FirstOrDefaultAsync();
                    if (note == null)
                    {
                        throw new NotFoundException(request.Note.NoteTitle, request.Note.NoteId);
                    }
                    else
                    {
                        note.NoteTitle = request.Note.NoteTitle;
                        note.Content = request.Note.Content;
                        note.LastModifiedDate = localDateTime.ToUniversalTime();
                        note.LastModifiedBy = request.Id;
                        note.TenantId = request.TenantId;
                        await _dbContext.SaveChangesAsync();

                        CrmNoteTags? noteTags = await (from a in _dbContext.CrmNoteTags.Where(a => a.NoteId == request.Note.NoteId)
                                                       select a).FirstOrDefaultAsync();
                        if (noteTags != null)
                        {
                            await _dbContext.Database.ExecuteSqlRawAsync("DELETE FROM \"CrmNoteTags\" WHERE \"NoteId\" = {0}", noteTags.NoteId);

                        }

                        List<int> TagIds = new List<int>();
                        if (!string.IsNullOrEmpty(request.Note.Tags))
                            TagIds = (request.Note.Tags.Split(',').Select(Int32.Parse).ToList());
                        foreach (var item in TagIds)
                        {
                            CrmNoteTags tags = new CrmNoteTags();
                            tags.NoteId = note.NoteId;
                            tags.TagId = item;
                            tags.CreatedBy = request.Id;
                            tags.CreatedDate = localDateTime.ToUniversalTime();
                            tags.TenantId = request.TenantId;
                            await _dbContext.AddAsync(tags);
                            await _dbContext.SaveChangesAsync();
                        }
                        CrmNoteTasks? noteTasks = await (from a in _dbContext.CrmNoteTasks.Where(a => a.NoteId == request.Note.NoteId)
                                                         select a).FirstOrDefaultAsync();
                        if (noteTasks != null)
                        {
                            await _dbContext.Database.ExecuteSqlRawAsync("DELETE FROM \"CrmNoteTasks\" WHERE \"NoteId\" = {0}", noteTasks.NoteId);

                        }
                        foreach (var taskDto in request.Note?.Tasks ?? new List<SaveNoteTaskDto>())
                        {

                            var taskEntity = new CrmNoteTasks
                            {
                                NoteId = note.NoteId,
                                CreatedDate = localDateTime.ToUniversalTime(),
                                CreatedBy = request.Id,
                                TenantId = request.TenantId,
                                IsDeleted = 0,
                                Task = taskDto.Task,
                                IsCompleted = taskDto.IsCompleted == true ? 1 : 0
                            };
                            await _dbContext.AddAsync(taskEntity);
                            await _dbContext.SaveChangesAsync();
                        }

                        var result = _dbContext.Database.ExecuteSqlRaw(
                        "CALL public.InsertCrmUserActivityLog({0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8},{9})",
                         note.CreatedBy, (int)CrmEnum.UserActivityEnum.Note, 1, note.NoteTitle, note.CreatedBy, note.TenantId, note.ContactTypeId, note.NoteId, "Update", note.Id);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task DeletNote(DeleteNoteCommand request)
        {
            try
            {
                var note = await (from a in _dbContext.CrmNote.Where(a => a.NoteId == request.NoteId)
                                  select a).FirstOrDefaultAsync();
                if (note == null)
                {
                    throw new NotFoundException("noteId", request.NoteId);
                }
                else
                {
                    note.IsDeleted = 1;
                    note.DeletedBy = request.Id;
                    note.DeletedDate = DateTime.Now.ToUniversalTime();
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetDeletedNoteVm>> GetDeletedNotes(int TenantId, string Id)
        {
            try
            {
                List<GetDeletedNoteVm> noteDetail = await(from a in _dbContext.CrmNote.Where(a => a.TenantId == TenantId && a.IsDeleted == 1)
                                                                join user in _dbContext.AppUser on a.DeletedBy equals user.Id
                                                                select new GetDeletedNoteVm
                                                                {
                                                                    Id = a.NoteId,
                                                                    Title = a.NoteTitle,
                                                                    DeletedBy = user.FirstName + " " + user.LastName,
                                                                    DeletedDate = a.DeletedDate,
                                                                }).OrderBy(a => a.Title).ToListAsync();
                return noteDetail;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task RestoreNote(RestoreNoteCommand note)
        {
            try
            {
                var restoreNote = await(from a in _dbContext.CrmNote.Where(a => a.NoteId == note.NoteId)
                                          select a).FirstOrDefaultAsync();
                if (restoreNote == null)
                {
                    throw new NotFoundException("note", note);
                }
                else
                {
                    restoreNote.IsDeleted = 0;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task RestoreBulkNote(RestoreBulkNoteCommand note)
        {
            try
            {
                foreach (var noteId in note.NoteId)
                {
                    var noteDetail = await _dbContext.CrmNote
                        .Where(p => p.NoteId == noteId && p.IsDeleted == 1)
                        .FirstOrDefaultAsync();

                    if (noteDetail == null)
                    {
                        throw new NotFoundException(nameof(noteId), noteId);
                    }

                    noteDetail.IsDeleted = 0;
                }

                await _dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
