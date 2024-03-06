using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Dashboard.Commands.DeleteDashboard;
using ERPCubes.Application.Features.Crm.Dashboard.Commands.SaveDashboard;
using ERPCubes.Application.Features.Crm.Dashboard.Queries.GetDashboards;
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
    public class DashboardRepository : BaseRepository<CrmDashboard>, IAsyncDashboardRepository
    {
        public DashboardRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }

        public async Task DeleteDashboard(DeleteDashboardCommand dashboard)
        {
            try
            {
                var deleteDashboard = await(from a in _dbContext.CrmDashboard.Where(a => a.DashboardId == dashboard.DashboardId)
                                          select a).FirstOrDefaultAsync();
                if (deleteDashboard == null)
                {
                    throw new NotFoundException("dashboard", dashboard);
                }
                else
                {
                    deleteDashboard.IsDeleted = 1;
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

        public async Task<List<GetDashboardVm>> GetAllDashboard(int TenantId, string Id)
        {
            try
            {
                List<GetDashboardVm> dashboardDetail = await(from a in _dbContext.CrmDashboard.Where(a => a.TenantId == TenantId && a.IsDeleted == 0)
                                                         select new GetDashboardVm
                                                         {
                                                             DashboardId = a.DashboardId,
                                                             Name = a.Name,
                                                             Status = a.Status,
                                                             IsPrivate = a.IsPrivate,   
                                                             Widgets = a.Widgets,
                                                         }).OrderBy(a => a.Name).ToListAsync();
                return dashboardDetail;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task SaveDashboard(SaveDashboardCommand dashboard)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                if (dashboard.DashboardId == -1)
                {
                    CrmDashboard addDashboard = new CrmDashboard();
                    addDashboard.TenantId = dashboard.TenantId;
                    addDashboard.Name = dashboard.Name;
                    addDashboard.Status = dashboard.Status;
                    addDashboard.IsPrivate = dashboard.IsPrivate;
                    addDashboard.Widgets = dashboard.Widgets;
                    addDashboard.CreatedBy = dashboard.Id;
                    addDashboard.CreatedDate = localDateTime.ToUniversalTime();
                    await _dbContext.AddAsync(addDashboard);
                    await _dbContext.SaveChangesAsync();
                }
                else
                {
                    var existingDashboard= await(from a in _dbContext.CrmDashboard.Where(a => a.DashboardId == dashboard.DashboardId)
                                                select a).FirstAsync();
                    if (existingDashboard == null)
                    {
                        throw new NotFoundException(dashboard.Name, dashboard.DashboardId);
                    }
                    else
                    {
                        existingDashboard.Name = dashboard.Name;
                        existingDashboard.Status = dashboard.Status;
                        existingDashboard.IsPrivate = dashboard.IsPrivate;
                        existingDashboard.Widgets = dashboard.Widgets;
                        existingDashboard.LastModifiedBy = dashboard.Id;
                        existingDashboard.LastModifiedDate = localDateTime.ToUniversalTime();
                        await _dbContext.SaveChangesAsync();
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
