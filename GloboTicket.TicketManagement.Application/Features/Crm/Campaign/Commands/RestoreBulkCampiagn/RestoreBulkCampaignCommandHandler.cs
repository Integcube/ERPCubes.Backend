using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Campaign.Commands.RestoreCampaign;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Campaign.Commands.RestoreBulkCampiagn
{
    public class RestoreBulkCampaignCommandHandler : IRequestHandler<RestoreBulkCampaignCommand>
    {
        private readonly IAsyncCampaignRepository _campaignRepository;
        private readonly ILogger<RestoreBulkCampaignCommandHandler> _logger;
        public RestoreBulkCampaignCommandHandler(IAsyncCampaignRepository campaignRepository, ILogger<RestoreBulkCampaignCommandHandler> logger)
        {
            _campaignRepository = campaignRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(RestoreBulkCampaignCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _campaignRepository.RestoreBulkCampaign(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting product {request.CampaignId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
