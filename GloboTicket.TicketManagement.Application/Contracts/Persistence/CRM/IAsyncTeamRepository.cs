using ERPCubes.Application.Features.Crm.Team.Commands.DeleteTeam;
using ERPCubes.Application.Features.Crm.Team.Commands.RestoreBulkTeam;
using ERPCubes.Application.Features.Crm.Team.Commands.RestoreTeam;
using ERPCubes.Application.Features.Crm.Team.Commands.SaveTeam;
using ERPCubes.Application.Features.Crm.Team.Queries.GetDeletedTeams;
using ERPCubes.Application.Features.Crm.Team.Queries.GetTeams;
using ERPCubes.Domain.Entities;
using MediatR;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncTeamRepository : IAsyncRepository<CrmTeam>
    {
        Task<List<GetTeamsVm>> GetTeamsAsync(GetTeamsQuery request);
        Task<Unit> SaveTeamAsync(SaveTeamCommand request);
        Task DeleteTeamAsync(DeleteTeamCommand productId);
        Task<List<GetDeletedTeamVm>> GetDeletedTeams(int TenantId, string Id);
        Task RestoreTeam(RestoreTeamCommand team);
        Task RestoreBulkTeam(RestoreBulkTeamCommand team);
    }
}
