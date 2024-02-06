using ERPCubes.Application.Contracts.Persistence.Social.Webhooks;
using ERPCubes.Application.Contracts.Persistence.TenantChecker;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Social.Webhooks.Instagram.Commands;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.TenantChecker
{
    public class TenantCheckerQueryHandler : IRequestHandler<TenantCheckerQuery, bool>
    {
        private readonly IAsyncTenantRepository _tenantRepository;
        private readonly ILogger<TenantCheckerQueryHandler> _logger;
        public TenantCheckerQueryHandler(IAsyncTenantRepository instaRepository, ILogger<TenantCheckerQueryHandler> logger)
        {
            _logger = logger;
            _tenantRepository = instaRepository;
        }
        public async Task<bool> Handle(TenantCheckerQuery request, CancellationToken cancellationToken)
        {
            try
            {
                bool message = await _tenantRepository.CheckTenant(request.Subdomain);
                return message;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving Instagram message caused error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
