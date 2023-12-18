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

namespace ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportuntiySource
{
    public class GetOpportunitySourceQueryHandler: IRequestHandler<GetOpportunitySourceQuery, List<GetOpportunitySourceVm>>
    {
        private readonly ILogger<GetOpportunitySourceQueryHandler> _logger;
        private readonly IAsyncOpportunityRepository _opportunityRepository;
        public GetOpportunitySourceQueryHandler(ILogger<GetOpportunitySourceQueryHandler> logger, IAsyncOpportunityRepository opportunityRepository)
        {
            _logger = logger;
            _opportunityRepository = opportunityRepository;
        }
        public async Task<List<GetOpportunitySourceVm>> Handle(GetOpportunitySourceQuery request, CancellationToken token)
        {
            List<GetOpportunitySourceVm> opportunity = new List<GetOpportunitySourceVm>();
            try
            {
                opportunity = await _opportunityRepository.GetOpportunitySource(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Opportunity Source List failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return opportunity;
        }
    }
}
