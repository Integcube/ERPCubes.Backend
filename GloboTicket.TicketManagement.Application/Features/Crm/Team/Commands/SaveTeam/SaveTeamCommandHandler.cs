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

namespace ERPCubes.Application.Features.Crm.Team.Commands.SaveTeam
{
    public class SaveTeamCommandHandler : IRequestHandler<SaveTeamCommand>
    {
        private readonly IAsyncTeamRepository _crmteamRepository;
        private readonly ILogger<SaveTeamCommandHandler> _logger;
        public SaveTeamCommandHandler(IAsyncTeamRepository crmteamRepository, ILogger<SaveTeamCommandHandler> logger)
        {
            _crmteamRepository = crmteamRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveTeamCommand request, CancellationToken token)
        {
            try
            {
                var obj = await _crmteamRepository.SaveTeamAsync(request);
                return Unit.Value;
            }
            catch(Exception ex)
            {
                _logger.LogError($"Saving Team :{request.TeamName} failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            
        }
    }
}
