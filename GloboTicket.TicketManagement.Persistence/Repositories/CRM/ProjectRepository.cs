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
                CrmProject? Project = await(
                    from a in _dbContext.CrmProject.Where(a => a.ProjectId == deleteProject.ProjectId)
                    select a ).FirstOrDefaultAsync();
                if (Project == null)
                {
                    throw new NotFoundException("Project Not Found: ", deleteProject.ProjectId);
                }
                else
                {
                    Project.IsDeleted = 1;
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
