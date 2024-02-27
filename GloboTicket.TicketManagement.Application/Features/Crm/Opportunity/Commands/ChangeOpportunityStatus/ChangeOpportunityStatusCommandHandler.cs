using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Industry.Queries.GetIndustryList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Commands.ChangeOpportunityStatus
{
    public class ChangeOpportunityStatusCommandHandler : IRequestHandler<ChangeOpportunityStatusCommand>
    {
        private readonly IAsyncOpportunityRepository _opportunityRepository;
        private readonly ILogger<ChangeOpportunityStatusCommandHandler> _logger;
        public ChangeOpportunityStatusCommandHandler(IAsyncOpportunityRepository opportunityRepository, ILogger<ChangeOpportunityStatusCommandHandler> logger)
        {
            _opportunityRepository = opportunityRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(ChangeOpportunityStatusCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _opportunityRepository.ChangeOpportunityStatus(request);
            }
            catch(Exception ex)
            {
                _logger.LogError($"Deleting Opportunity {request.OpportunityId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;

        }
    }
}
