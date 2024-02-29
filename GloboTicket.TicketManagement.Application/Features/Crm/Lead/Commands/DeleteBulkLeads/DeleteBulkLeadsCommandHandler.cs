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

namespace ERPCubes.Application.Features.Crm.Lead.Commands.DeleteBulkLeads
{
    public class DeleteBulkLeadsCommandHandler : IRequestHandler<DeleteBulkLeadsCommand>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<DeleteBulkLeadsCommandHandler> _logger;
        public DeleteBulkLeadsCommandHandler(IAsyncLeadRepository leadRepository, ILogger<DeleteBulkLeadsCommandHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(DeleteBulkLeadsCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _leadRepository.DeleteBulkLead(request);
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
