using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.AdAccount.Commands.SaveAdAccount;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.AdAccount.Commands.BulkSaveAdAccount
{
    public class SaveBulkAdAccountHandler : IRequestHandler<SaveBulkAdAccountCommand>
    {
        private readonly IAsyncAdAccountRepository _adRepository;
        private readonly ILogger<SaveBulkAdAccountHandler> _logger;

        public SaveBulkAdAccountHandler(IAsyncAdAccountRepository adRepository, ILogger<SaveBulkAdAccountHandler> logger)
        {
            _adRepository = adRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveBulkAdAccountCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _adRepository.SaveAdAccountBulk( request );
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving ad {request.AdAccount} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);

            }
            return Unit.Value;
        }
    }
}
