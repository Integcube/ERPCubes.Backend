using ERPCubes.Application.Features.Crm.Project.Commands.DeleteProject;
using ERPCubes.Application.Features.Crm.Project.Commands.RestoreBulkProject;
using ERPCubes.Application.Features.Crm.Project.Commands.RestoreProject;
using ERPCubes.Application.Features.Crm.Project.Commands.SaveProject;
using ERPCubes.Application.Features.Crm.Project.Queries.GetDeletedProjects;
using ERPCubes.Application.Features.Crm.Project.Queries.GetProjects;
using ERPCubes.Domain.Entities;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncProjectRepository : IAsyncRepository<CrmProject>
    {
        Task<List<GetProjectsVm>> GetProjects(GetProjectsQuery getProjects);
        Task SaveProject(SaveProjectCommand saveProject);
        Task DeleteProject(DeleteProjectCommand deleteProject);
        Task<List<GetDeletedProjectVm>> GetDeletedProjects(int TenantId, string Id);
        Task RestoreProject(RestoreProjectCommand project);
        Task RestoreBulkProject(RestoreBulkProjectCommand project);
    }
}
