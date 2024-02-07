using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveForm;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Call.Commands.Delete
{
    public class DeleteCommandHandler : IRequestHandler<DeleteCommand>
    {
        private readonly IAsyncFormsRepository _formsRepository;
       
        public DeleteCommandHandler(IAsyncFormsRepository formsRepository, ILogger<DeleteCommandHandler> logger)
        {
             _formsRepository = formsRepository;
           
        }

        public async Task<Unit> Handle(DeleteCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _formsRepository.Delete(request);
            }
            catch (Exception ex)
            {
               
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
