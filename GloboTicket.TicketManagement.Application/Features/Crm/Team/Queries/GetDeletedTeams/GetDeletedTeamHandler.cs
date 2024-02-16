using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Team.Queries.GetTeams;
using ERPCubes.Application.Features.Notes.Queries.GetDeletedNotes;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Team.Queries.GetDeletedTeams
{
    public class GetDeletedTeamHandler : IRequestHandler<GetDeletedTeamQuery, List<GetDeletedTeamVm>>
    {
        private readonly IAsyncTeamRepository _teamRepository;
        private readonly ILogger<GetDeletedTeamHandler> _logger;
        public GetDeletedTeamHandler(IAsyncTeamRepository teamRepository, ILogger<GetDeletedTeamHandler> logger)
        {
            _teamRepository = teamRepository;
            _logger = logger;
        }

        public async Task<List<GetDeletedTeamVm>> Handle(GetDeletedTeamQuery request, CancellationToken cancellationToken)
        {
            List<GetDeletedTeamVm> notes = new List<GetDeletedTeamVm>();
            try
            {
                notes = await _teamRepository.GetDeletedTeams(request.TenantId, request.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting team list failed due to an error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return notes;
        }
    }
}
