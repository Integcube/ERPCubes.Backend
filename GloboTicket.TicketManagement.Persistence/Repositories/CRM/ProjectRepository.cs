using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Project.Commands.DeleteProject;
using ERPCubes.Application.Features.Crm.Project.Commands.SaveProject;
using ERPCubes.Application.Features.Crm.Project.Queries.GetProjects;
using ERPCubes.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using ERPCubes.Identity;
using Microsoft.EntityFrameworkCore;
using ERPCubes.Application.Features.Crm.Project.Queries.GetDeletedProjects;
using ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList;
using ERPCubes.Application.Features.Crm.Project.Commands.RestoreProject;
using ERPCubes.Application.Features.Crm.Project.Commands.RestoreBulkProject;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class ProjectRepository: BaseRepository<CrmProject>, IAsyncProjectRepository
    {
        public ProjectRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity)
        {
        }
        public async Task<List<GetProjectsVm>> GetProjects(GetProjectsQuery getProjects)
        {
            try

            {
                List<GetProjectsVm> projects = await(
                    from a in _dbContext.CrmProject.Where(a => a.TenantId == getProjects.TenantId && a.IsDeleted == 0)                                                                       
                    select new GetProjectsVm
                    {
                        ProjectId = a.ProjectId,
                        Title = a.Title,
                        CompanyId = a.CompanyId,
                        Code =  a.Code,
                        Budget = a.Budget,
                        Description = a.Description,
                    }
                    ).OrderByDescending(a => a.ProjectId).ToListAsync();
                return projects;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
        public async Task SaveProject(SaveProjectCommand saveProject)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                if (saveProject.ProjectId == -1)
                {
                    CrmProject ProjectObj = new CrmProject();
                    ProjectObj.Title = saveProject.Title;
                    ProjectObj.CompanyId = saveProject.CompanyId;
                    ProjectObj.Code = saveProject.Code;
                    ProjectObj.Budget = saveProject.Budget;
                    ProjectObj.Description = saveProject.Description;
                    ProjectObj.CreatedBy = saveProject.Id;
                    ProjectObj.CreatedDate = localDateTime.ToUniversalTime();
                    ProjectObj.TenantId = saveProject.TenantId;
                    await _dbContext.AddAsync(ProjectObj);
                    await _dbContext.SaveChangesAsync();

                }
                else
                {
                    CrmProject? existingProject = await (from a in _dbContext.CrmProject.Where(a => a.ProjectId == saveProject.ProjectId)
                                                    select a).FirstAsync();
                    if (existingProject == null)
                    {
                        throw new NotFoundException("Project Not Found: ", saveProject.Title);
                    }
                    else
                    {
                        existingProject.Title = saveProject.Title;
                        existingProject.CompanyId = saveProject.CompanyId;
                        existingProject.Code = saveProject.Code;
                        existingProject.Budget = saveProject.Budget;
                        existingProject.Description = saveProject.Description;
                        existingProject.LastModifiedBy = saveProject.Id;
                        existingProject.LastModifiedDate = localDateTime.ToUniversalTime();
                        await _dbContext.SaveChangesAsync();
                    }                  
                }
            }
            catch (Exception e)
            {
                throw new BadRequestException(e.Message);
            }
        }
        public async Task DeleteProject(DeleteProjectCommand deleteProject)
        {
            try
            {
                CrmProject? project = await(
                    from a in _dbContext.CrmProject.Where(a => a.ProjectId == deleteProject.ProjectId)
                    select a ).FirstOrDefaultAsync();
                if (project == null)
                {
                    throw new NotFoundException("Project Not Found: ", deleteProject.ProjectId);
                }
                else
                {
                    project.IsDeleted = 1;
                    project.DeletedBy = deleteProject.Id;
                    project.DeletedDate = DateTime.Now.ToUniversalTime();
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task<List<GetDeletedProjectVm>> GetDeletedProjects(int TenantId, string Id)
        {
            try
            {
                List<GetDeletedProjectVm> projectDetail = await(from a in _dbContext.CrmProject.Where(a => a.TenantId == TenantId && a.IsDeleted == 1)
                                                                join user in _dbContext.AppUser on a.DeletedBy equals user.Id
                                                                select new GetDeletedProjectVm
                                                                {
                                                                    Id = a.ProjectId,
                                                                    Title = a.Title,
                                                                    DeletedBy = user.FirstName + " " + user.LastName,
                                                                    DeletedDate = a.DeletedDate,
                                                                }).OrderBy(a => a.Title).ToListAsync();
                return projectDetail;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task RestoreProject(RestoreProjectCommand project)
        {
            try
            {
                var restoreProject = await(from a in _dbContext.CrmProject.Where(a => a.ProjectId == project.ProjectId)
                                           select a).FirstOrDefaultAsync();
                if (restoreProject == null)
                {
                    throw new NotFoundException("project", project);
                }
                else
                {
                    restoreProject.IsDeleted = 0;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task RestoreBulkProject(RestoreBulkProjectCommand project)
        {
            try
            {
                foreach (var projectId in project.ProjectId)
                {
                    var projectDetail = await _dbContext.CrmProject
                        .Where(p => p.ProjectId == projectId && p.IsDeleted == 1)
                        .FirstOrDefaultAsync();

                    if (projectDetail == null)
                    {
                        throw new NotFoundException(nameof(projectId), projectId);
                    }

                    projectDetail.IsDeleted = 0;
                }

                await _dbContext.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
