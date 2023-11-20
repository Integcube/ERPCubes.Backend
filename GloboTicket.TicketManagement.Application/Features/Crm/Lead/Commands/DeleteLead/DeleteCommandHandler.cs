using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Industry.Queries.GetIndustryList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.DeleteLead
{
    public class DeleteCommandHandler : IRequestHandler<DeleteLeadCommand>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<DeleteCommandHandler> _logger;
        public DeleteCommandHandler(IAsyncLeadRepository leadRepository, ILogger<DeleteCommandHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(DeleteLeadCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _leadRepository.DeleteLead(request.Id, request.TenantId, request.LeadId, request.Name);
            }
            catch(Exception ex)
            {
                _logger.LogError($"Deleting lead {request.Name} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;

        }
    }
}
