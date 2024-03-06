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

namespace ERPCubes.Application.Features.Crm.Dashboard.Commands.DeleteDashboard
{
    public class DeleteDashboardCommandHandler : IRequestHandler<DeleteDashboardCommand>
    {
        private readonly IAsyncDashboardRepository _dashboardRepository;
        private readonly ILogger<DeleteDashboardCommandHandler> _logger;

        public DeleteDashboardCommandHandler(IAsyncDashboardRepository dashboardRepository, ILogger<DeleteDashboardCommandHandler> logger)
        {
            _dashboardRepository = dashboardRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(DeleteDashboardCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _dashboardRepository.DeleteDashboard(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving dashboard {request.DashboardId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);

            }
            return Unit.Value;
        }
    }
}
