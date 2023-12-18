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

namespace ERPCubes.Application.Features.Crm.Opportunity.Commands.DeleteOpportunity
{
    public class DeleteOpportunityCommandHandler: IRequestHandler<DeleteOpportunityCommand>
    {
        private readonly ILogger<DeleteOpportunityCommandHandler> _logger;
        private readonly IAsyncOpportunityRepository _opportunityRepository;
        public DeleteOpportunityCommandHandler(ILogger<DeleteOpportunityCommandHandler> logger, IAsyncOpportunityRepository opportunityRepository)
        {
            _logger = logger;
            _opportunityRepository = opportunityRepository;
        }
        public async Task<Unit> Handle(DeleteOpportunityCommand request, CancellationToken token)
        {
            try
            {
                await _opportunityRepository.DeleteOpportunity(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting Opportunity has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
