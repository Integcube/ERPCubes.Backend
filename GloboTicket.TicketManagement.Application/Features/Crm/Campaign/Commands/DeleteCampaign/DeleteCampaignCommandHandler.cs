using ERPCubes.Application.Contracts.Persistence.CRM;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Campaign.Commands.DeleteCampaign
{
    public class DeleteCampaignCommandHandler : IRequestHandler<DeleteCampaignCommand>
    {
        private readonly IAsyncCampaignRepository _campaignRepository;
        private readonly ILogger<DeleteCampaignCommandHandler> _logger;
        public DeleteCampaignCommandHandler(IAsyncCampaignRepository campaignRepository, ILogger<DeleteCampaignCommandHandler> logger)
        {
            _campaignRepository = campaignRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(DeleteCampaignCommand request, CancellationToken token)
        {
            try
            {
                await _campaignRepository.DeleteCampaign(request);

            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting Campaign {request.CampaignId} failed due to : {ex.Message}");
                throw new Exception(ex.Message);
            }
            return Unit.Value;
        }
    }
}
