

using ERPCubes.Application.Contracts.Persistence.CRM;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ERPCubes.Application.Features.Crm.Opportunity.Queries.GetDeletedOpportunity
{
    public class GetDeletedOpportunityQueryHandler : IRequestHandler<GetDeletedOpportunityQuery, List<GetDeletedOpportunityVm>>
        {
        private readonly IAsyncOpportunityRepository _opportunityRepository;
        private readonly ILogger<GetDeletedOpportunityQueryHandler> _logger;
        public GetDeletedOpportunityQueryHandler(IAsyncOpportunityRepository opportunityRepository, ILogger<GetDeletedOpportunityQueryHandler> logger)
        {
            _opportunityRepository = opportunityRepository;
            _logger = logger;
        }
        public async Task<List<GetDeletedOpportunityVm>> Handle(GetDeletedOpportunityQuery request, CancellationToken token)
        {
            try
            {
                List<GetDeletedOpportunityVm> dOpportunity = new List<GetDeletedOpportunityVm>();
                dOpportunity = await (_opportunityRepository.GetDeletedOpportunity(request.TenantId, request.Id));
                return dOpportunity;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Deleted Opportunity has failed due to an error : {ex.Message}");
                throw new Exception();
            }
        }
    }
}
    
