using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunityAttachments
{
    public class GetOpportunityAttachmentsQueryHandler : IRequestHandler<GetOpportunityAttachmentsQuery, List<GetOpportunityAttachmentsVm>>
    {
        private IAsyncOpportunityRepository _opportunityRepository;
        private ILogger<GetOpportunityAttachmentsQueryHandler> _logger;
        public GetOpportunityAttachmentsQueryHandler(IAsyncOpportunityRepository opportunityRepository, ILogger<GetOpportunityAttachmentsQueryHandler> logger)
        {
            _opportunityRepository = opportunityRepository;
            _logger = logger;
        }
        public async Task<List<GetOpportunityAttachmentsVm>> Handle(GetOpportunityAttachmentsQuery query, CancellationToken token)
        {
            try
            {
                List<GetOpportunityAttachmentsVm> attachments = new List<GetOpportunityAttachmentsVm>();
                attachments = await (_opportunityRepository.GetOpportunityAttachments(query));
                return attachments;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Opportunity Attachments failed due to {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
