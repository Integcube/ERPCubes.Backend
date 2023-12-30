using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Reports.Queries.GetCampaigWiseReport;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class ReportsRepository : BaseRepository<CrmLead>, IAsyncReportsRepository
    {
        public ReportsRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }
        public async Task<List<GetCampaigWiseReportQueryVm>> GetCampaigWiseReport(GetCampaigWiseReportQuery obj)
        {
            try
            {
                var tenantIdPrm = new Npgsql.NpgsqlParameter("@TenantId", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = obj.TenantId
                };
                var SourceIdPrm = new Npgsql.NpgsqlParameter("@p_SourceId", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = obj.SourceId
                };
                var Campaign = new Npgsql.NpgsqlParameter("@Campaign", NpgsqlTypes.NpgsqlDbType.Varchar)
                {
                    Value = obj.Campaign
                };

                var startDatePrm = new Npgsql.NpgsqlParameter("@SourceId", NpgsqlTypes.NpgsqlDbType.Date)
                {
                    Value = obj.StartDate
                };
                var endDatePrm = new Npgsql.NpgsqlParameter("@EndDate", NpgsqlTypes.NpgsqlDbType.Date)
                {
                    Value = obj.EndDate
                };
                var ProductId = new Npgsql.NpgsqlParameter("@ProductId", NpgsqlTypes.NpgsqlDbType.Integer)
                {
                    Value = obj.ProductId
                };
                
                var results = await _dbContext.GetCampaigWiseReportQueryVm.FromSqlRaw(
                    "SELECT * FROM public.crmcampaignwiserpt({0},{1},{2},{3},{4},{5})", tenantIdPrm, SourceIdPrm, Campaign, startDatePrm,endDatePrm, ProductId)
                    .ToListAsync();

                return results;
            }


            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

    }
}
