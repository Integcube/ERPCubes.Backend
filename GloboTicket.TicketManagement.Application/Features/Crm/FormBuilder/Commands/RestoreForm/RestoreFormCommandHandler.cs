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

namespace ERPCubes.Application.Features.Crm.FormBuilder.Commands.RestoreForm
{
    public class RestoreFormCommandHandler : IRequestHandler<RestoreFormCommand>
    {
        private readonly IAsyncFormsRepository _formsRepository;

        public RestoreFormCommandHandler(IAsyncFormsRepository formsRepository, ILogger<RestoreFormCommandHandler> logger)
        {
            _formsRepository = formsRepository;

        }

        public async Task<Unit> Handle(RestoreFormCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _formsRepository.RestoreForm(request);
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
