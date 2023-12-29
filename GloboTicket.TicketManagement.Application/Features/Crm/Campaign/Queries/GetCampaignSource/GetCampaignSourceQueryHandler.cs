using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Features.Crm.Campaign.Queries.GetCampaign;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Campaign.Queries.GetCampaignSource
{
    public class GetCampaignSourceQueryHandler: IRequestHandler<GetCampaignSourceQuery, List<GetCampaignSourceVm>>
    {
        private readonly IAsyncCampaignRepository _campaignRepository;
        private readonly ILogger<GetCampaignSourceQueryHandler> _logger;
        public GetCampaignSourceQueryHandler(IAsyncCampaignRepository campaignRepository, ILogger<GetCampaignSourceQueryHandler> logger)
        {
            _campaignRepository = campaignRepository;
            _logger = logger;
        }
        public async Task<List<GetCampaignSourceVm>> Handle(GetCampaignSourceQuery request, CancellationToken token)
        {
            List<GetCampaignSourceVm> campaigns = new List<GetCampaignSourceVm>();
            try
            {
                campaigns = await _campaignRepository.GetCampaignSource(request);

            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting all Campaign Sources failed due to : {ex.Message}");
                throw new Exception(ex.Message);
            }
            return campaigns;
        }
    }
}
