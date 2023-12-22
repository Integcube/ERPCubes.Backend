using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Notes.Commands.DeleteNote;
using ERPCubes.Application.Features.Notes.Commands.SaveNote;
using ERPCubes.Application.Features.Notes.Queries.GetNoteList;
using ERPCubes.Application.Features.Notes.Queries.GetNotesWithTasks;
using ERPCubes.Application.Features.Notes.Queries.GetNoteTags;
using ERPCubes.Application.Features.Notes.Queries.GetNoteTask;
using ERPCubes.Application.Models.Mail;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class NoteRepository : BaseRepository<CrmNote>, IAsyncNoteRepository
    {
        public NoteRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task<List<GetNoteListVm>> GetNoteList(int TenantId, string Id, int LeadId, int CompanyId, int OpportunityId)
        {
            try
            {
                List<GetNoteListVm> Notes = await (
                    from a in _dbContext.CrmNote.Where(a => a.IsDeleted == 0 && a.TenantId == TenantId &&
                    (Id == "-1" || a.CreatedBy == Id) &&
                    (LeadId == -1 || (a.Id == LeadId && a.IsLead == 1)) &&
                    (CompanyId == -1 || (a.Id == CompanyId && a.IsCompany == 1)) &&
                    (OpportunityId == -1 || (a.Id == OpportunityId && a.IsOpportunity == 1)))
                    select new GetNoteListVm
                    {
                        NoteId = a.NoteId,
                        NoteTitle = a.NoteTitle,
                        Content = a.Content,
                        CreatedBy = a.CreatedBy,
                        CreatedDate = a.CreatedDate,
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
                var notes = await (from a in _dbContext.CrmNote.Where(a => a.TenantId == TenantId && a.CreatedBy == Id && a.IsLead == -1 && a.IsCompany == -1 && a.IsOpportunity == -1)
                                   join b in _dbContext.CrmNoteTags on a.NoteId equals b.NoteId into all1
                                   from bb in all1.DefaultIfEmpty()
                                   join d in _dbContext.CrmTags on bb.TagId equals d.TagId into all3
                                   from dd in all3.DefaultIfEmpty()
                                   join c in _dbContext.CrmNoteTasks on a.NoteId equals c.NoteId into all2
                                   from cc in all2.DefaultIfEmpty()
                                   select new
                                   {
                                       a.NoteId,
                                       a.NoteTitle,
                                       a.CreatedDate,
                                       bb.TagId,
                                       dd.TagTitle,
                                       cc.Task,
                                       cc.NoteTaskId,
                                       cc.IsCompleted,
                                   }).ToListAsync();
                List<GetNotesWithTasksVm> result = notes.GroupBy(
           n => new { n.NoteId, n.NoteTitle, n.CreatedDate },
           (key, group) => new GetNotesWithTasksVm
           {
               NoteId = key.NoteId,
               Content = string.Empty,
               NoteTitle = key.NoteTitle,
               CreatedDate = key.CreatedDate,
               Tags = group.Where(g => g.TagId != null).Select(g => new GetNotesTagsDto
               {
                   TagId = g.TagId,
                   TagTitle = g.TagTitle ?? string.Empty
               }).ToList(),
               Tasks = group.Where(g => g.NoteTaskId != null).Select(g => new GetNotesTaskDto
               {
                   TaskId = g.NoteTaskId,
                   TaskTitle = g.Task ?? string.Empty,
                   IsCompleted = g.IsCompleted == 1 ? true : false
               }).ToList()
           }).ToList();

                return result;
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

                                                    }
                                                   ).OrderByDescending(a => a.TaskId).ToListAsync();

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
                    if (request.CompanyId == -1)
                    {
                        note.IsCompany = -1;
                    }
                    else
                    {
                        note.IsCompany = 1;
                        note.Id = request.CompanyId;
                    }
                    if (request.LeadId == -1)
                    {
                        note.IsLead = -1;
                    }
                    else
                    {
                        note.IsLead = 1;
                        note.Id = request.LeadId;
                    }
                    if (request.OpportunityId == -1)
                    {
                        note.IsOpportunity = -1;
                    }
                    else
                    {
                        note.IsOpportunity = 1;
                        note.Id = request.OpportunityId;
                    }
                    if (request.LeadId == -1 && request.CompanyId == -1 && request.OpportunityId == -1)
                    {
                        note.Id = -1;
                    }
                    await _dbContext.AddAsync(note);
                    await _dbContext.SaveChangesAsync();

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

                    CrmUserActivityLog ActivityObj = new CrmUserActivityLog();
                    ActivityObj.UserId = note.CreatedBy;
                    ActivityObj.Detail = note.Content;
                    ActivityObj.ActivityType = 4;
                    ActivityObj.ActivityStatus = 1;
                    ActivityObj.TenantId = note.TenantId;
                    if (request.CompanyId == -1)
                    {
                        ActivityObj.IsCompany = -1;
                    }
                    else
                    {
                        ActivityObj.IsCompany = 1;
                        ActivityObj.Id = request.CompanyId;
                    }
                    if (request.LeadId == -1)
                    {
                        ActivityObj.IsLead = -1;
                    }
                    else
                    {
                        ActivityObj.IsLead = 1;
                        ActivityObj.Id = request.LeadId;
                    }
                    if (request.OpportunityId == -1)
                    {
                        ActivityObj.IsOpportunity = -1;
                    }
                    else
                    {
                        ActivityObj.IsOpportunity = 1;
                        ActivityObj.Id = request.OpportunityId;
                    }
                    if (request.LeadId == -1 && request.CompanyId == -1 && request.OpportunityId == -1)
                    {
                        ActivityObj.Id = -1;
                    }
                    ActivityObj.CreatedBy = ActivityObj.CreatedBy;
                    ActivityObj.CreatedDate = localDateTime.ToUniversalTime();
                    await _dbContext.CrmUserActivityLog.AddAsync(ActivityObj);
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
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

    }
}
