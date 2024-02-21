using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetleadPiplineReport;
using ERPCubes.Application.Features.Product.Commands.SaveProduct;
using ERPCubes.Domain.Entities;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Setting.Queries.GetChatBotSetting
{

    public class GetChatBotSettingQueryHandler : IRequestHandler<GetChatBotSettingQuery, GetChatBotSettingQueryVm>
    {
        private readonly IAsyncCrmSettingRepository _productRepository;
        private readonly ILogger<GetChatBotSettingQueryHandler> _logger;

        public GetChatBotSettingQueryHandler(IAsyncCrmSettingRepository productRepository, ILogger<GetChatBotSettingQueryHandler> logger)
        {
            _productRepository = productRepository;
            _logger = logger;
        }

        public async Task<GetChatBotSettingQueryVm> Handle(GetChatBotSettingQuery request, CancellationToken cancellationToken)
        {
            GetChatBotSettingQueryVm products = new GetChatBotSettingQueryVm();
            try
            {
                 products = await _productRepository.GetChatbotSetting(request.TenantId);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting about product list failed due to an error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return products;
        }
    }
}
