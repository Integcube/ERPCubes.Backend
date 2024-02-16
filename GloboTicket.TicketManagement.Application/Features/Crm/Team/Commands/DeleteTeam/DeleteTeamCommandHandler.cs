using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Task.Commands.DeleteTask;
using ERPCubes.Application.Features.Product.Commands.DeleteProduct;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Team.Commands.DeleteTeam
{
    public class DeleteTeamCommandHandler : IRequestHandler<DeleteTeamCommand>
    {
        private readonly ILogger<DeleteTeamCommandHandler> _logger;
        private readonly IAsyncTeamRepository _crmteamRepository;
        public DeleteTeamCommandHandler(IAsyncTeamRepository crmteamRepository, ILogger<DeleteTeamCommandHandler> logger)
        {
            _crmteamRepository = crmteamRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(DeleteTeamCommand request, CancellationToken token)
        {
            try
            {
                await _crmteamRepository.DeleteTeamAsync(request);
                return Unit.Value;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting Team :{request.TeamId} failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
