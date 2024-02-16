using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Call.Commands.Delete;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Commands.RestoreBulkForm
{
    public class RestoreBulkFormCommandHanlder : IRequestHandler<ResotreBulkFormCommand>
    {
        private readonly IAsyncFormsRepository _formsRepository;

        public RestoreBulkFormCommandHanlder(IAsyncFormsRepository formsRepository, ILogger<RestoreBulkFormCommandHanlder> logger)
        {
            _formsRepository = formsRepository;

        }

        public async Task<Unit> Handle(ResotreBulkFormCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _formsRepository.RestoreBulkForm(request);
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
