using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetleadPiplineReport;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Reports.Queries.GetCampaigWiseReport
{
  
    public class GetCampaigWiseReportQueryHandler : IRequestHandler<GetCampaigWiseReportQuery, List<GetCampaigWiseReportQueryVm>>
    {
        private readonly IAsyncReportsRepository _productRepository;
        private readonly ILogger<GetCampaigWiseReportQueryHandler> _logger;

        public GetCampaigWiseReportQueryHandler(IAsyncReportsRepository productRepository, ILogger<GetCampaigWiseReportQueryHandler> logger)
        {
            _productRepository = productRepository;
            _logger = logger;
        }

        public async Task<List<GetCampaigWiseReportQueryVm>> Handle(GetCampaigWiseReportQuery request, CancellationToken cancellationToken)
        {
            List<GetCampaigWiseReportQueryVm> products = new List<GetCampaigWiseReportQueryVm>();
            try
            {
                products = await _productRepository.GetCampaigWiseReport(request);
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
