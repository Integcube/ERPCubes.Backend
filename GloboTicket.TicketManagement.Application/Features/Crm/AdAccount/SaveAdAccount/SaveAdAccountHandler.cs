using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Call.Commands.SaveCall;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.AdAccount.SaveAdAccount
{
    public class SaveAdAccountHandler : IRequestHandler<SaveAdAccountCommand>
    {
        private readonly IAsyncAdAccountRepository _adRepository;
        private readonly ILogger<SaveAdAccountHandler> _logger;

        public SaveAdAccountHandler(IAsyncAdAccountRepository adRepository, ILogger<SaveAdAccountHandler> logger)
        {
            _adRepository = adRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveAdAccountCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _adRepository.SaveAdAccount(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving ad {request.AccountId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);

            }
            return Unit.Value;
        }
    }
}
