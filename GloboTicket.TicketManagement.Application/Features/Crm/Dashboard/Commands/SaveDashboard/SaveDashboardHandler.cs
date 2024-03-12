using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Dashboard.Queries.GetDashboards;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Dashboard.Commands.SaveDashboard
{
    public class SaveDashboardHandler : IRequestHandler<SaveDashboardCommand>
    {
        private readonly IAsyncDashboardRepository _dashboardRepository;
        private readonly ILogger<SaveDashboardHandler> _logger;

        public SaveDashboardHandler(IAsyncDashboardRepository dashboardRepository, ILogger<SaveDashboardHandler> logger)
        {
            _dashboardRepository = dashboardRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(SaveDashboardCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _dashboardRepository.SaveDashboard(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving dashboard {request.Dashboard.DashboardId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);

            }
            return Unit.Value;
        }
    }
}
