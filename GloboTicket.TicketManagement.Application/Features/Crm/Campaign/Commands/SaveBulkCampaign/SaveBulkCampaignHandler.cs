using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Campaign.Commands.SaveCampaign
{
    public class SaveBulkCampaignHandler : IRequestHandler<SaveBulkCampaignCommand>
    {
        private readonly IAsyncCampaignRepository _campaignRepository;
        private readonly ILogger<SaveBulkCampaignHandler> _logger;

        public SaveBulkCampaignHandler(IAsyncCampaignRepository campaignRepository, ILogger<SaveBulkCampaignHandler> logger)
        {
            _campaignRepository = campaignRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(SaveBulkCampaignCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _campaignRepository.SaveBulkCampaigns(new List<SaveBulkCampaignCommand> { request });
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving campaign {request.CampaignId} failed due to: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }

            return Unit.Value;
        }
    }
}
