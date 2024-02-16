using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Campaign.Queries.GetCampaignSource;
using ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Campaign.Queries.GetDeletedCampaigns
{
    public class GetDeletedCampaignHandler : IRequestHandler<GetDeletedCampaignQuery, List<GetDeletedCampaignVm>>
    {
        private readonly IAsyncCampaignRepository _campaignRepository;
        private readonly ILogger<GetDeletedCampaignHandler> _logger;
        public GetDeletedCampaignHandler(IAsyncCampaignRepository campaignRepository, ILogger<GetDeletedCampaignHandler> logger)
        {
            _campaignRepository = campaignRepository;
            _logger = logger;
        }

        public async Task<List<GetDeletedCampaignVm>> Handle(GetDeletedCampaignQuery request, CancellationToken cancellationToken)
        {
            List<GetDeletedCampaignVm> campaigns = new List<GetDeletedCampaignVm>();
            try
            {
                campaigns = await _campaignRepository.GetDeletedCampaigns(request.TenantId, request.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting product list failed due to an error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return campaigns;
        }
    }
}
