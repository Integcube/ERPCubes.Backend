using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Industry.Queries.GetIndustryList;
using ERPCubes.Application.Features.Crm.Lead.Commands.ChangeBulkLeadStatus;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.ChangeBulkLeadStatus
{
    public class ChangeBulkLeadStatusCommandHandler : IRequestHandler<ChangeBulkLeadStatusCommand>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<ChangeBulkLeadStatusCommandHandler> _logger;
        public ChangeBulkLeadStatusCommandHandler(IAsyncLeadRepository leadRepository, ILogger<ChangeBulkLeadStatusCommandHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(ChangeBulkLeadStatusCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _leadRepository.ChangeBulkLeadStatus(request);
            }
            catch(Exception ex)
            {
                _logger.LogError($"Deleting Bulk leads {request.Leads} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;

        }
    }
}
