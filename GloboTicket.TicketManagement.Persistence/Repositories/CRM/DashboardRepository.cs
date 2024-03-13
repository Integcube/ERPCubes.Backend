using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Dashboard.Commands.DeleteDashboard;
using ERPCubes.Application.Features.Crm.Dashboard.Commands.SaveDashboard;
using ERPCubes.Application.Features.Crm.Dashboard.Commands.SaveDashboardWidgets;
using ERPCubes.Application.Features.Crm.Dashboard.Queries.GetDashboards;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using MediatR;
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
                                                             join user in _dbContext.AppUser on a.CreatedBy equals user.Id
                                                             select new GetDashboardVm
                                                         {
                                                             DashboardId = a.DashboardId,
                                                             Name = a.Name,
                                                             Status = a.Status,
                                                             IsPrivate = a.IsPrivate,
                                                             Widgets= a.Widgets,
                                                             CreatedBy= user.FirstName + " " + user.LastName,
                                                             CreatedDate = a.CreatedDate,
                                                         }).OrderBy(a => a.CreatedDate).ToListAsync();
                return dashboardDetail;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task SaveDashboard(SaveDashboardCommand request)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                if (request.Dashboard.DashboardId == -1)
                {
                    CrmDashboard addDashboard = new CrmDashboard();
                    addDashboard.TenantId = request.TenantId;
                    addDashboard.Name = request.Dashboard.Name;
                    addDashboard.Status = request.Dashboard.Status;
                    addDashboard.IsPrivate = request.Dashboard.IsPrivate;
                    addDashboard.Widgets = request.Dashboard.Widgets;
                    addDashboard.CreatedBy = request.Id;
                    addDashboard.IsDeleted = 0;
                    addDashboard.CreatedDate = localDateTime.ToUniversalTime();
                    await _dbContext.AddAsync(addDashboard);
                    await _dbContext.SaveChangesAsync();
                }
                else
                {
                    var existingDashboard= await(from a in _dbContext.CrmDashboard.Where(a => a.DashboardId == request.Dashboard.DashboardId)
                                                select a).FirstAsync();
                    if (existingDashboard == null)
                    {
                        throw new NotFoundException(request.Dashboard.Name, request.Dashboard.DashboardId);
                    }
                    else
                    {
                        existingDashboard.Name = request.Dashboard.Name;
                        existingDashboard.Status = request.Dashboard.Status;
                        existingDashboard.IsPrivate = request.Dashboard.IsPrivate;
                        existingDashboard.Widgets = request.Dashboard.Widgets;
                        existingDashboard.LastModifiedBy = request.Id;
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

        public async Task SaveDashboardWidget(SaveDashboardWidgetsCommand dashboard)
        {
            try
            {
                var widgets = await (from a in _dbContext.CrmDashboard.Where(a => a.DashboardId == dashboard.DashboardId)
                                     select a).FirstAsync();
                if (widgets == null)
                {
                    throw new NotFoundException(dashboard.Widgets, dashboard.DashboardId);
                }
                else
                {
                    widgets.Widgets = dashboard.Widgets;
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
