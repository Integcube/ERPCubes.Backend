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
    public class SaveCampaignHandler : IRequestHandler<SaveCampaignCommand>
    {
        private readonly IAsyncCampaignRepository _campaignRepository;
        private readonly ILogger<SaveCampaignHandler> _logger;

        public SaveCampaignHandler(IAsyncCampaignRepository campaignRepository, ILogger<SaveCampaignHandler> logger)
        {
            _campaignRepository = campaignRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(SaveCampaignCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _campaignRepository.SaveCampaigns(new List<SaveCampaignCommand> { request });
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
