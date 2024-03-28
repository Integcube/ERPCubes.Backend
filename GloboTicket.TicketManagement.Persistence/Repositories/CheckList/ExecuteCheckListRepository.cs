using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.CheckList.ExecuteCheckList.Commands.GetAssignedCheckList;
using ERPCubes.Application.Features.CheckList.ExecuteCheckList.Commands.GetAssignedCheckPoint;
using ERPCubes.Application.Features.CheckList.ExecuteCheckList.Queries.SetStatus;
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
    public class ExecuteCheckListRepository : BaseRepository<CkCheckList>, IAsyncExecuteCheckListRepository
    {
        public ExecuteCheckListRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task<List<GetAssignedCheckListVm>> GetAssignedCheckList(GetAssignedCheckListQuery request)
        {
            try
            {
                var checklistDetail = await (from a in _dbContext.CkCheckList.Where(a=>a.TenantId == request.TenantId && a.IsDeleted == 0)
                                             join b in _dbContext.CKExecCheckList.Where(b => b.IsDeleted == 0) on a.CLId equals b.CLId
                                             join c in _dbContext.CkUserCheckPoint.Where(c => c.IsDeleted == 0 && c.AssignTo == request.Id) on b.ExecId equals c.ExecId
                                             join u in _dbContext.AppUser on b.CreatedBy equals u.Id
                                             select new GetAssignedCheckListVm
                                             {
                                                 Title = a.Title,
                                                 CreatedBy = u.FirstName+" "+ u.LastName,
                                                 Description = a.Description,
                                                 AssignedDate = b.CreatedDate,
                                                 CLId = a.CLId,
                                                 ExecId = b.ExecId,
                                                 Remarks = b.Remarks,
                                             }).Distinct().OrderBy(a => a.AssignedDate).ToListAsync();

                return checklistDetail;
            }
            catch (Exception ex)
            {

                throw new Exception("An error occurred while fetching assigned checklists.", ex);
            }
        }

        public async Task<List<GetAssignedCheckPointVm>> GetAssignedCheckPoint(GetAssignedCheckPointQuery request)
        {
            try
            {
                var checklistDetail = await (from a in _dbContext.CKExecCheckList.Where(b => b.ExecId == request.ExecId)
                                             join c in _dbContext.CkUserCheckPoint.Where(c => c.IsDeleted == 0 && c.AssignTo == request.Id) on a.ExecId equals c.ExecId
                                             join e in _dbContext.CKCheckPoint.Where(c => c.IsDeleted == 0) on c.CPId equals e.CPId
                                             join d in _dbContext.CkUserCheckPointExec.Where(c => c.IsDeleted == 0) on new { c.ExecId, c.CPId, UserId = request.Id } equals new { d.ExecId, d.CPId, d.UserId } into all
                                             from dd in all.DefaultIfEmpty()
                                             select new GetAssignedCheckPointVm
                                             {
                                                 CLId = a.CLId,
                                                 CPId = c.CPId,
                                                 Title = e.Title,
                                                 Description = e.Description,
                                                 IsRequired = e.IsRequired,
                                                 DueDays = e.DueDays,
                                                 DueDate = e.CreatedDate.AddDays(e.DueDays),
                                                 Status = dd==null?-1: dd.Status,
                                                 Priority = (int)(e.Priority==null?-1: e.Priority),
                                             }).Distinct().OrderBy(a => a.DueDate).ToListAsync();

                return checklistDetail;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }



        public async Task SetStatus(SetStatusCommand request)
        {
            try
            {
                var existing = await _dbContext.CkUserCheckPointExec.FirstOrDefaultAsync(c => c.CPId == request.CPId && c.ExecId == request.ExecId && c.TenantId == request.TenantId && c.UserId == request.Id);
                if (existing == null)
                {
                    CkUserCheckPointExec chkL = new CkUserCheckPointExec();
                    chkL.CreatedDate = DateTime.Now.ToUniversalTime();
                    chkL.TenantId = request.TenantId;
                    chkL.IsDeleted = 0;
                    chkL.CreatedBy = request.Id;
                    chkL.Status = request.StatusId;
                    chkL.CPId = request.CPId;
                    chkL.ExecId = request.ExecId;
                    chkL.UserId = request.Id;
                    chkL.ExecId = request.ExecId;
                    await _dbContext.AddAsync(chkL);
                    await _dbContext.SaveChangesAsync();

                }
                else
                {
                    existing.LastModifiedDate = DateTime.Now.ToUniversalTime();
                    existing.LastModifiedBy = request.Id;
                    existing.Status = request.StatusId;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch(Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }

        }
    }
}
