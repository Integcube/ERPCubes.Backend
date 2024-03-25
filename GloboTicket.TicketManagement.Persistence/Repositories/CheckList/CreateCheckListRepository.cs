using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Checklist.Command.SaveChecklist;
using ERPCubes.Application.Features.Crm.Checklist.Queries.GetChecklists;
using ERPCubes.Application.Features.Crm.Dashboard.Queries.GetDashboards;
using ERPCubes.Application.Features.Notes.Commands.SaveNote;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class CreateCheckListRepository : BaseRepository<CkCheckList>, IAsyncCreateCheckListRepository
    {
        public CreateCheckListRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task<List<GetChecklistVm>> GetAllChecklist(int TenantId, string Id)
        {
            try
            {
                List<GetChecklistVm> checklistDetail = await(from a in _dbContext.CkCheckList.Where(a => a.TenantId == TenantId && a.IsDeleted == 0)
                                                             join user in _dbContext.AppUser on a.CreatedBy equals user.Id
                                                             select new GetChecklistVm
                                                             {
                                                                 CLId = a.CLId,
                                                                 Title = a.Title,
                                                                 Description=a.Description,
                                                                 CreatedBy = user.FirstName + " " + user.LastName,
                                                                 //CreatedDate = a.CreatedDate,
                                                             }).OrderBy(a => a.Title).ToListAsync();
                return checklistDetail;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task SaveChecklist(SaveChecklistCommand request)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                if (request.Checklist.CLId == -1)
                {
                    CkCheckList checklist = new CkCheckList();
                    checklist.Title = request.Checklist.Title;
                    checklist.Description = request.Checklist.Description;
                    checklist.CreatedDate = localDateTime.ToUniversalTime();
                    checklist.CreatedBy = request.Id;
                    checklist.TenantId = request.TenantId;
                    checklist.IsDeleted = 0;

                    await _dbContext.AddAsync(checklist);
                    await _dbContext.SaveChangesAsync();

                
                    foreach (var checkpointDto in request.Checklist?.Checkpoints ?? new List<SaveChecklistPointsDto>())
                    {

                        var checkpointEntity = new CKCheckPoint
                        {
                            CLId = checklist.CLId,

                            CreatedDate = localDateTime.ToUniversalTime(),
                            CreatedBy = request.Id,
                            TenantId = request.TenantId,
                            IsDeleted = 0,
                            Description = checkpointDto.Description,
                        };
                        await _dbContext.AddAsync(checkpointEntity);
                        await _dbContext.SaveChangesAsync();
                    }

                    await _dbContext.SaveChangesAsync();
                }
                else
                {
                    var checklist = await (from a in _dbContext.CkCheckList.Where(a => a.CLId == request.Checklist.CLId)
                                      select a).FirstOrDefaultAsync();
                    if (checklist == null)
                    {
                        throw new NotFoundException(request.Checklist.Title, request.Checklist.CLId);
                    }
                    else
                    {
                        checklist.Title = request.Checklist.Title;
                        checklist.Description = request.Checklist.Description;
                        //checklist.LastModifiedDate = localDateTime.ToUniversalTime();
                        //checklist.LastModifiedBy = request.Id;
                        checklist.TenantId = request.TenantId;
                        await _dbContext.SaveChangesAsync();

                     
                       
                        CKCheckPoint? checkpoints = await (from a in _dbContext.CKCheckPoint.Where(a => a.CLId == request.Checklist.CLId)
                                                         select a).FirstOrDefaultAsync();
                        //if (checkpoints != null)
                        //{
                        //    await _dbContext.Database.ExecuteSqlRawAsync("DELETE FROM \"CrmNoteTasks\" WHERE \"NoteId\" = {0}", noteTasks.NoteId);

                        //}
                        foreach (var checkpointDto in request.Checklist?.Checkpoints ?? new List<SaveChecklistPointsDto>())
                        {

                            var checkpointEntity = new CKCheckPoint
                            {
                                CLId = checklist.CLId,
                                CreatedDate = localDateTime.ToUniversalTime(),
                                CreatedBy = request.Id,
                                TenantId = request.TenantId,
                                IsDeleted = 0,
                                Description = checkpointDto.Description,
                            };
                            await _dbContext.AddAsync(checkpointEntity);
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
    }
}
