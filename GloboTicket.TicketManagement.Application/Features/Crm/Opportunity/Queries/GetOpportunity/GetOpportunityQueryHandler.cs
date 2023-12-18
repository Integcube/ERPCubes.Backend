using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunity
{
    public class GetOpportunityQueryHandler: IRequestHandler<GetOpportunityQuery, List<GetOpportunityVm>>
    {
        private readonly ILogger _logger;
        private readonly IAsyncOpportunityRepository _opportunityRepository;
        public GetOpportunityQueryHandler(ILogger<GetOpportunityQueryHandler> logger, IAsyncOpportunityRepository opportunityRepository)
        {
            _logger = logger;
            _opportunityRepository = opportunityRepository;
        }
        public async Task<List<GetOpportunityVm>> Handle(GetOpportunityQuery request, CancellationToken token)
        {
            List<GetOpportunityVm> opportunity = new List<GetOpportunityVm>();
            try
            {
                opportunity = await _opportunityRepository.GetOpportunity(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Opportunity list failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return opportunity;
        }
    }
}
