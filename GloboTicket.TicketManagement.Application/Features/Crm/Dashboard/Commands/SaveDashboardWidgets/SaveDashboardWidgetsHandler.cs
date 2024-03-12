using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Dashboard.Commands.SaveDashboard;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Dashboard.Commands.SaveDashboardWidgets
{
    public class SaveDashboardWidgetsHandler : IRequestHandler<SaveDashboardWidgetsCommand>
    {
        private readonly IAsyncDashboardRepository _dashboardRepository;
        private readonly ILogger<SaveDashboardWidgetsHandler> _logger;

        public SaveDashboardWidgetsHandler(IAsyncDashboardRepository dashboardRepository, ILogger<SaveDashboardWidgetsHandler> logger)
        {
            _dashboardRepository = dashboardRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(SaveDashboardWidgetsCommand request, CancellationToken cancellationToken)
        {

            try
            {
                await _dashboardRepository.SaveDashboardWidget(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving widget {request.DashboardId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);

            }
            return Unit.Value;
        }
    }
}
