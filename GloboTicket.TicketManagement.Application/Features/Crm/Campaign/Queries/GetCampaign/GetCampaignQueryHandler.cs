using ERPCubes.Application.Contracts.Persistence.CRM;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ERPCubes.Application.Features.Crm.Campaign.Queries.GetCampaign
{
    public class GetCampaignQueryHandler: IRequestHandler<GetCampaignQuery, List<GetCampaignVm>>
    {
        private readonly IAsyncCampaignRepository _campaignRepository;
        private readonly ILogger<GetCampaignQueryHandler> _logger;
        public GetCampaignQueryHandler(IAsyncCampaignRepository campaignRepository, ILogger<GetCampaignQueryHandler> logger)
        {
            _campaignRepository = campaignRepository;
            _logger = logger;
        }
        public async Task<List<GetCampaignVm>> Handle(GetCampaignQuery request, CancellationToken token)
        {
            List<GetCampaignVm> campaigns = new List<GetCampaignVm>();
            try 
            {
                campaigns = await (_campaignRepository.GetCampaign(request));

            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting all Campaigns failed due to : {ex.Message}");
                throw new Exception(ex.Message);
            }
            return campaigns;
        }
    }
}
