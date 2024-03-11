using ERPCubes.Application.Contracts.Persistence.Infrastructure;
using ERPCubes.Application.Contracts.Persistence.TenantChecker;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ERPCubes.Application.Features.Crm.Tenant.Commands.SaveTenant
{
    public class SaveTenantCommandHandler : IRequestHandler<SaveTenantCommand>
    {
        private readonly IAsyncTenantRepository _Repository;
        private readonly ILogger<SaveTenantCommandHandler> _logger;
        private readonly IEmailService _emailService;
        public SaveTenantCommandHandler(IAsyncTenantRepository Repository, ILogger<SaveTenantCommandHandler> logger, IEmailService emailservice )
        {
            _Repository = Repository;
            _logger = logger;
            _emailService = emailservice;
        }
        public async Task<Unit> Handle(SaveTenantCommand request, CancellationToken cancellationToken)
        {
            try
            {

                var aaa =   _Repository.SaveTenant(request);
               
                //_emailService.SendEmail(aaa);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving Tenant {request.Company} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
