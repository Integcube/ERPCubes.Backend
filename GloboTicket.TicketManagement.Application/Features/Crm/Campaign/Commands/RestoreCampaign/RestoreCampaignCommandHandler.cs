using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Campaign.Commands.DeleteCampaign;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Campaign.Commands.RestoreCampaign
{
    public class RestoreCampaignCommandHandler : IRequestHandler<RestoreCampaignCommand>
    {
        private readonly IAsyncCampaignRepository _campaignRepository;
        private readonly ILogger<RestoreCampaignCommandHandler> _logger;
        public RestoreCampaignCommandHandler(IAsyncCampaignRepository campaignRepository, ILogger<RestoreCampaignCommandHandler> logger)
        {
            _campaignRepository = campaignRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(RestoreCampaignCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _campaignRepository.RestoreCampaign(request);
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
