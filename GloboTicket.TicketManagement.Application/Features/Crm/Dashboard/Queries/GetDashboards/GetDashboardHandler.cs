using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Product.Queries.GetProductList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Dashboard.Queries.GetDashboards
{
    public class GetDashboardHandler : IRequestHandler<GetDashboardQuery, List<GetDashboardVm>>
    {
        private readonly IAsyncDashboardRepository _dashboardRepository;
        private readonly ILogger<GetDashboardHandler> _logger;

        public GetDashboardHandler(IAsyncDashboardRepository dashboardRepository, ILogger<GetDashboardHandler> logger)
        {
            _dashboardRepository = dashboardRepository;
            _logger = logger;
        }

        public async Task<List<GetDashboardVm>> Handle(GetDashboardQuery request, CancellationToken cancellationToken)
        {
            List<GetDashboardVm> dashboards = new List<GetDashboardVm>();
            try
            {
                dashboards = await _dashboardRepository.GetAllDashboard(request.TenantId, request.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting product list failed due to an error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return dashboards;
        }
    }
}
