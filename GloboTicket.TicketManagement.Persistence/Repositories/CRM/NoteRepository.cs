using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadList;
using ERPCubes.Application.Features.Notes.Queries.GetNoteList;
using ERPCubes.Application.Features.Notes.Queries.GetNoteTags;
using ERPCubes.Application.Features.Notes.Queries.GetNoteTask;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class NoteRepository : BaseRepository<CrmNote>, IAsyncNoteRepository
    {
        public NoteRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task<List<GetNoteListVm>> GetNoteList(int TenantId, string Id, int LeadId, int CompanyId)
        {
            try
            {
                List<GetNoteListVm> Notes = await (from a in _dbContext.CrmNote.Where(a => a.IsDeleted == 0 && a.TenantId == TenantId && (Id == "-1" || a.CreatedBy == Id) && (LeadId == -1 || a.Id == LeadId) && (CompanyId == -1 || a.Id == CompanyId))
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

        public async Task<List<NoteTagListVm>> GetNoteTagList(int TenantId, string Id, int NoteId)
        {
            try
            {
                List<NoteTagListVm> Tags = await (from a in _dbContext.CrmNoteTags.Where(a => a.TenantId == TenantId && a.NoteId == NoteId)
                                                   join c in _dbContext.CrmTags.Where(a=>a.IsDeleted == 0) on a.TagId equals c.TagId
                                                   select new NoteTagListVm
                                                   {
                                                       NoteId = a.NoteId,
                                                       TagId = c.TagId,
                                                       TagTitle = c.TagTitle,
                                                       NoteTagId = a.NoteTagsId,
                                                       IsSelected = a.TagId == null ? false : true,
                                                   }
                                                   ).OrderByDescending(a=>a.TagTitle).ToListAsync();

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
                List<NoteTaskListVm> Tasks = await(from b in _dbContext.CrmNoteTasks.Where(a => a.IsDeleted == 0 && a.NoteId == NoteId)
                                                   select new NoteTaskListVm
                                                  {
                                                      NoteId = b.NoteId,
                                                      TaskId = b.NoteTaskId,
                                                      Task = b.Task,
                                                      IsCompleted = b.IsCompleted == 0?false:true,
                                                      
                                                  }
                                                   ).OrderByDescending(a=>a.TaskId).ToListAsync();

                return Tasks;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
