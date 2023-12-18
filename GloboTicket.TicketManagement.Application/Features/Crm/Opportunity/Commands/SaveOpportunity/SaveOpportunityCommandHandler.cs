using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunity;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Commands.SaveOpportunity
{
    public class SaveOpportunityCommandHandler: IRequestHandler<SaveOpportunityCommand>
    {
        private readonly ILogger<SaveOpportunityCommandHandler> _logger;
        private readonly IAsyncOpportunityRepository _opportunityRepository;
        public SaveOpportunityCommandHandler(ILogger<SaveOpportunityCommandHandler> logger, IAsyncOpportunityRepository opportunityRepository)
        {
            _logger = logger;
            _opportunityRepository = opportunityRepository;
        }
        public async Task<Unit> Handle(SaveOpportunityCommand request, CancellationToken token)
        {
            try
            {
                await _opportunityRepository.SaveOpportunity(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving Opportunity has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
