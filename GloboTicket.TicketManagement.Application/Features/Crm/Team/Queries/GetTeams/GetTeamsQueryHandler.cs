using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ERPCubes.Application.Features.Crm.Team.Queries.GetTeams
{
    public class GetTeamsQueryHandler : IRequestHandler<GetTeamsQuery, List<GetTeamsVm>>
    {
        private readonly IAsyncTeamRepository _teamRepository;
        private readonly ILogger<GetTeamsQueryHandler> _logger;
        public GetTeamsQueryHandler(IAsyncTeamRepository teamRepository, ILogger<GetTeamsQueryHandler> logger)
        {
            _teamRepository = teamRepository;
            _logger = logger;
        }
        public async Task<List<GetTeamsVm>> Handle(GetTeamsQuery request, CancellationToken token)
        {
            try
            {
                var obj = await _teamRepository.GetTeamsAsync(request);
                return obj;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Teams List failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
