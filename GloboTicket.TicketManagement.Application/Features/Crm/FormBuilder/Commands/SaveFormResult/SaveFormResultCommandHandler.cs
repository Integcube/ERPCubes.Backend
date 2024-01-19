using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveFormFields;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveFormResult
{
    public class SaveFormResultCommandHandler: IRequestHandler<SaveFormResultCommand>
    {
        private readonly IAsyncFormsRepository _formsRepository;
        private readonly ILogger<SaveFormResultCommandHandler> _logger;
        public SaveFormResultCommandHandler(IAsyncFormsRepository formsRepository, ILogger<SaveFormResultCommandHandler> logger)
        {
            _formsRepository = formsRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveFormResultCommand request, CancellationToken token)
        {
            try
            {
                await _formsRepository.SaveFormResult(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"FormResult could not be saved due to: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
