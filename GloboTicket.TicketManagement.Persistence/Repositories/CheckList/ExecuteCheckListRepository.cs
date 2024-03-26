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

        public Task<List<GetAssignedCheckListVm>> GetAssignedCheckList(GetAssignedCheckListQuery request)
        {
            throw new NotImplementedException();
        }

        public Task<List<GetAssignedCheckPointVm>> GetAssignedCheckPoint(GetAssignedCheckPointQuery request)
        {
            throw new NotImplementedException();
        }

        public Task SaveAssignedChecklist(SaveChecklistCommand request)
        {
            throw new NotImplementedException();
        }



        public async Task SetStatus(SetStatusCommand request)
        {
            try
            {
                //var existing= await _dbContext.CkUserCheckPointExec.FirstOrDefaultAsync(c => c.ExecId == request.ExecId && c.CPId == request.CpId && c.UserId==request.UserId);
                // if(existing != null)
                //{
                //    CkUserCheckPointExec chkL = new CkUserCheckPointExec();
                //    chkL.CreatedDate = DateTime.Now.ToUniversalTime();
                //    chkL.TenantId = request.TenantId;
                //    chkL.IsDeleted = 0;
                //    chkL.CreatedBy = request.Id;
                //    chkL.CLId = request.CLId;
                //    chkL.Remarks = request.Remarks;
                //    await _dbContext.AddAsync(chkL);
                //    await _dbContext.SaveChangesAsync();

                //}

            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
