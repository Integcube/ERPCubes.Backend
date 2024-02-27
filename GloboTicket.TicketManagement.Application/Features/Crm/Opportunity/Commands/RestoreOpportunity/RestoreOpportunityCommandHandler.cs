using ERPCubes.Application.Contracts.Persistence.CRM;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Commands.RestoreOpportunity
{
    public class RestoreOpportunityCommandHandler: IRequestHandler<RestoreOpportunityCommand>
    {
        private IAsyncOpportunityRepository _opportuntiyRepository;
        private ILogger<RestoreOpportunityCommandHandler> _logger;
        public RestoreOpportunityCommandHandler(IAsyncOpportunityRepository repository, ILogger<RestoreOpportunityCommandHandler> logger)
        {
            _opportuntiyRepository = repository;
            _logger = logger;
        }
        public async Task<Unit> Handle(RestoreOpportunityCommand command, CancellationToken token)
        {
            try
            {
                await _opportuntiyRepository.RestoreOpportunity(command);
            }
            catch (Exception ex)
            {
                _logger.LogError($"There was a problem restoring Deleted Opportunity(s) due to: {ex.Message}");
                throw new Exception(ex.Message);
            }
            return Unit.Value;
        }
    }
}
