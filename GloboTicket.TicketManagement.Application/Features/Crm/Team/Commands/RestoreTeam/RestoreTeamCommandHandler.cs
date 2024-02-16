using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Team.Commands.DeleteTeam;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Team.Commands.RestoreTeam
{
    public class RestoreTeamCommandHandler : IRequestHandler<RestoreTeamCommand>
    {
        private readonly ILogger<RestoreTeamCommandHandler> _logger;
        private readonly IAsyncTeamRepository _crmteamRepository;
        public RestoreTeamCommandHandler(IAsyncTeamRepository crmteamRepository, ILogger<RestoreTeamCommandHandler> logger)
        {
            _crmteamRepository = crmteamRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(RestoreTeamCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _crmteamRepository.RestoreTeam(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting team {request.TeamId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
