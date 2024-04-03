using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.AssignCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.AssigntToLeadsCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.DeleteAssignCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetExcutedCheckListbyId;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.LazyGetAssignCheckList;
using ERPCubes.Application.Features.Crm.Checklist.Queries.CheckListReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadList;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetleadPiplineReport;
using ERPCubes.Application.Models.Mail;
using ERPCubes.Domain.Common;
using ERPCubes.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class CheckListReportsRepository : IAsyncCheckListReportRepository
    {
        protected readonly ERPCubesDbContext _dbContext;

        public CheckListReportsRepository(ERPCubesDbContext dbContext)
        {
            _dbContext = dbContext;

        }

        public async Task<List<CheckListReportVm>> CheckListReport(CheckListReportQuery request)
        {
            try
            {
                var tenantIdPrm = new Npgsql.NpgsqlParameter("@TenantId", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = request.TenantId
                };
                var results = await _dbContext.CheckListReportVm.FromSqlRaw("SELECT * FROM \"CkCheckListReport\"(@TenantId)", tenantIdPrm).ToListAsync();
                return results;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }



    }
}
