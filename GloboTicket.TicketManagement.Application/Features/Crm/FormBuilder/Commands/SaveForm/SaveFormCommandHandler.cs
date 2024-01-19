using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveForm
{
    public class SaveFormCommandHandler: IRequestHandler<SaveFormCommand>
    {
        private readonly IAsyncFormsRepository _formsRepository;
            private readonly ILogger<SaveFormCommandHandler> _logger;
        public SaveFormCommandHandler(IAsyncFormsRepository formsRepository, ILogger<SaveFormCommandHandler> logger)
        {
            _formsRepository = formsRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveFormCommand request, CancellationToken token)
        {
            try
            {
                await _formsRepository.SaveForm(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Could not save Form: {request.FormId} due to: {ex.Message}");
                throw new BadRequestException(ex.Message );

            }
            return Unit.Value;
        }
    }
}
