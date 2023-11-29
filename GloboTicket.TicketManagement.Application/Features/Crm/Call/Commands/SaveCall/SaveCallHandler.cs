using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Email.Commands.SaveEmail;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Call.Commands.SaveCall
{
    public class SaveCallHandler : IRequestHandler<SaveCallCommand>
    {
        private readonly IAsyncCallRepository _callRepository;
        private readonly ILogger<SaveCallHandler> _logger;

        public SaveCallHandler(IAsyncCallRepository callRepository, ILogger<SaveCallHandler> logger)
        {
            _callRepository = callRepository;
            _logger = logger;
        }
    
        public async Task<Unit> Handle(SaveCallCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _callRepository.SaveCall(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving call {request.CallId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);

            }
            return Unit.Value;
        }
    }
}
