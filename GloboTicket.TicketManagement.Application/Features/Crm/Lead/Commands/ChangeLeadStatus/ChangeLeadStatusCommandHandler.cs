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

namespace ERPCubes.Application.Features.Crm.Lead.Commands.ChangeLeadStatus
{
    public class ChangeLeadStatusCommandHandler : IRequestHandler<ChangeLeadStatusCommand>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<ChangeLeadStatusCommandHandler> _logger;
        public ChangeLeadStatusCommandHandler(IAsyncLeadRepository leadRepository, ILogger<ChangeLeadStatusCommandHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(ChangeLeadStatusCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _leadRepository.ChangeLeadStatus(request);
            }
            catch(Exception ex)
            {
                _logger.LogError($"Deleting lead {request.LeadId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;

        }
    }
}
