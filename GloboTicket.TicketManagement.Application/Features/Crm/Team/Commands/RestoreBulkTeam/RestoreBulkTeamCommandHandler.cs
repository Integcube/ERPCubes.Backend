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

namespace ERPCubes.Application.Features.Crm.Team.Commands.RestoreBulkTeam
{
    public class RestoreBulkTeamCommandHandler : IRequestHandler<RestoreBulkTeamCommand>
    {
        private readonly ILogger<RestoreBulkTeamCommandHandler> _logger;
        private readonly IAsyncTeamRepository _crmteamRepository;
        public RestoreBulkTeamCommandHandler(IAsyncTeamRepository crmteamRepository, ILogger<RestoreBulkTeamCommandHandler> logger)
        {
            _crmteamRepository = crmteamRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(RestoreBulkTeamCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _crmteamRepository.RestoreBulkTeam(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting note {request.TeamId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
