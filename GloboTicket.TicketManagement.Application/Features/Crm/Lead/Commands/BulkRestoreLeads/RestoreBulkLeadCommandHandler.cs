using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Product.Commands.BulkRestoreProduct;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.BulkRestoreLeads
{
    public class RestoreBulkLeadCommandHandler : IRequestHandler<RestoreBulkLeadCommand>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<RestoreBulkLeadCommandHandler> _logger;
        public RestoreBulkLeadCommandHandler(IAsyncLeadRepository leadRepository, ILogger<RestoreBulkLeadCommandHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;

        }
        public async Task<Unit> Handle(RestoreBulkLeadCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _leadRepository.RestoreBulkLead(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Restoring lead {request.LeadId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
