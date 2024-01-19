using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Commands.DeleteLead;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveFormFields
{
    public class SaveFormFieldsCommandHandler: IRequestHandler<SaveFormFieldsCommand>
    {
        private readonly IAsyncFormsRepository _formsRepository;
        private readonly ILogger<SaveFormFieldsCommandHandler> _logger;
        public SaveFormFieldsCommandHandler(IAsyncFormsRepository formsRepository, ILogger<SaveFormFieldsCommandHandler> logger)
        {
            _formsRepository = formsRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveFormFieldsCommand request, CancellationToken token)
        {
            try
            {
                await _formsRepository.SaveFormFields(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"FormFields could not be saved due to: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
