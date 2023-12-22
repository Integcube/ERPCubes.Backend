using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadStatus;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunityStatus
{
    public class GetOpportunityStatusQueryHandler : IRequestHandler<GetOpportunityStatusQuery, List<GetOpportunityStatusVm>>
    {
        private readonly IAsyncOpportunityRepository _opportunityRepository;
        private readonly ILogger<GetOpportunityStatusQueryHandler> _logger;
        public GetOpportunityStatusQueryHandler(IAsyncOpportunityRepository opportunityRepository, ILogger<GetOpportunityStatusQueryHandler> logger)
        {
            _opportunityRepository = opportunityRepository;
            _logger = logger;
        }
        public async Task<List<GetOpportunityStatusVm>> Handle(GetOpportunityStatusQuery request, CancellationToken token)
        {
            List<GetOpportunityStatusVm> statusList = new List<GetOpportunityStatusVm>();
            try
            {
                statusList = await _opportunityRepository.GetOpportunityStatus(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Opportunity Status list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return statusList;
        }
    }
}
