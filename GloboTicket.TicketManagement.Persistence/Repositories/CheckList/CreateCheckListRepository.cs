using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.CheckList.CreateCheckList.DeleteCreateChecklist;
using ERPCubes.Application.Features.CheckList.CreateCheckList.Queries.GetCheckpoints;
using ERPCubes.Application.Features.CheckList.CreateCheckList.Queries.GetCreateCheckListbyId;
using ERPCubes.Application.Features.Crm.Checklist.Command.SaveChecklist;
using ERPCubes.Application.Features.Crm.Checklist.Queries.GetChecklists;
using ERPCubes.Application.Features.Crm.Dashboard.Queries.GetDashboards;
using ERPCubes.Application.Features.Notes.Commands.SaveNote;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using ERPCubes.Identity.Models;
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

        public async Task Delete(DeleteCreateChecklistCommand request)
        {
            try
            {
                var deleteChecklist = await (from a in _dbContext.CkCheckList.Where(a => a.CLId == request.CLId)
                                             select a).FirstOrDefaultAsync();
                if (deleteChecklist == null)
                {
                    throw new NotFoundException("checklist", request);
                }
                else
                {
                    deleteChecklist.IsDeleted = 1;
                    //deleteDashboard.DeletedBy = dashboard.Id;
                    //deleteDashboard.DeletedDate = DateTime.Now.ToUniversalTime();
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetChecklistVm>> GetAllChecklist(int TenantId, string Id)
        {
            try
            {
                List<GetChecklistVm> checklistDetail = await (from a in _dbContext.CkCheckList.Where(a => a.TenantId == TenantId && a.IsDeleted == 0)
                                                              join user in _dbContext.AppUser on a.CreatedBy equals user.Id
                                                              join ckcontact in _dbContext.CkContactCheckList.Where(a=>a.IsDeleted==0) on a.CLId equals ckcontact.CLId into abc
                                                              from cont in abc.DefaultIfEmpty()
                                                              select new GetChecklistVm
                                                              {
                                                                  ClId = a.CLId,
                                                                  Title = a.Title,
                                                                  Description = a.Description,
                                                                  CreatedBy = user.FirstName + " " + user.LastName,
                                                                  IAssign = cont == null ? 0 : 1
                                                              }).OrderByDescending(a => a.ClId).ToListAsync();
                return checklistDetail;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetCheckpointsVm>> GetAllCheckpoint(int TenantId, string Id, int CLId)
        {
            try
            {
                List<GetCheckpointsVm> checkpointDetail = await (from a in _dbContext.CKCheckPoint.Where(a => a.TenantId == TenantId && a.IsDeleted == 0 && a.CLId == CLId)
                                                                 select new GetCheckpointsVm
                                                                 {
                                                                     CLId = a.CLId,
                                                                     CPId = a.CPId,
                                                                     Title = a.Title,
                                                                     Description = a.Description,
                                                                     IsRequired = a.IsRequired,
                                                                     Priority = a.Priority,
                                                                     DueDays = a.DueDays,
                                                                     //CreatedDate = a.CreatedDate,
                                                                     IsDeleted = a.IsDeleted
                                                                 }).OrderByDescending(a => a.CLId).ToListAsync();
                return checkpointDetail;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<GetCreateCheckListbyIdVm> GetCreateCheckListbyId(GetCreateCheckListbyIdQuery request)
        {
            var checklist = await (from a in _dbContext.CkCheckList.Where(a => a.TenantId == request.TenantId && a.IsDeleted == 0 && a.CLId == request.CLId)
                                   join user in _dbContext.AppUser on a.CreatedBy equals user.Id
                                   select new GetCreateCheckListbyIdVm
                                   {
                                       ClId = a.CLId,
                                       Title = a.Title,
                                       Description = a.Description,

                                   }).FirstOrDefaultAsync();
            return checklist;
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
                            Title = checkpointDto.Title,
                            DueDays = checkpointDto.DueDays,
                            IsRequired = checkpointDto.IsRequired,
                            Priority = checkpointDto.Priority,
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
                        checklist.LastModifiedDate = localDateTime.ToUniversalTime();
                        checklist.LastModifiedBy = request.Id;
                        checklist.TenantId = request.TenantId;
                        await _dbContext.SaveChangesAsync();


                        foreach (var checkpointDto in request.Checklist?.Checkpoints ?? new List<SaveChecklistPointsDto>())
                        {

                            if (checkpointDto.CpId == -1)
                            {
                                var checkpointEntity = new CKCheckPoint
                                {


                                    CLId = checklist.CLId,
                                    CreatedDate = localDateTime.ToUniversalTime(),
                                    CreatedBy = request.Id,
                                    TenantId = request.TenantId,
                                    IsDeleted = 0,
                                    Title = checkpointDto.Title,
                                    DueDays = checkpointDto.DueDays,
                                    IsRequired = checkpointDto.IsRequired,
                                    Priority = checkpointDto.Priority,

                                };
                                await _dbContext.AddAsync(checkpointEntity);
                            }
                            else
                            {
                                CKCheckPoint checkpoints = await (from a in _dbContext.CKCheckPoint.Where(a => a.CPId == checkpointDto.CpId)
                                                                  select a).FirstOrDefaultAsync();

                                checkpoints.Title = checkpointDto.Title;
                                checkpoints.DueDays = checkpointDto.DueDays;
                                checkpoints.Priority = checkpointDto.Priority;
                                checkpoints.IsRequired = checkpointDto.IsRequired;
                                checkpoints.LastModifiedBy = request.Id;
                                checkpoints.IsDeleted = checkpointDto.IsDeleted;
                                checkpoints.LastModifiedDate = localDateTime.ToUniversalTime();

                            }

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
