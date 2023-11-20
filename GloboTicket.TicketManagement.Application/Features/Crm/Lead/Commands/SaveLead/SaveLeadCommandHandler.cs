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

namespace ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead
{
    public class SaveLeadCommandHandler : IRequestHandler<SaveLeadCommand>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<DeleteCommandHandler> _logger;
        public SaveLeadCommandHandler(IAsyncLeadRepository leadRepository, ILogger<DeleteCommandHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveLeadCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _leadRepository.SaveLead(request.Id, request.TenantId, request.Lead);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving lead {request.Lead.FirstName + "" + request.Lead.LastName} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
