using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Commands.BulkRestoreLeads;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Commands.RestoreBulkOpportunity
{
    public class RestoreBulkOpportunityCommandHandler : IRequestHandler<RestoreBulkOpportunityCommand>
    {
        private readonly IAsyncOpportunityRepository _opportunityRepository;
        private readonly ILogger<RestoreBulkOpportunityCommandHandler> _logger;
        public RestoreBulkOpportunityCommandHandler(IAsyncOpportunityRepository opportunityRepository, ILogger<RestoreBulkOpportunityCommandHandler> logger)
        {
            _opportunityRepository = opportunityRepository;
            _logger = logger;

        }
        public async Task<Unit> Handle(RestoreBulkOpportunityCommand command, CancellationToken cancellationToken)
        {
            try
            {
                await _opportunityRepository.RestoreBulkOpportunity(command);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Restoring opportunity {command.OpportunityId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
