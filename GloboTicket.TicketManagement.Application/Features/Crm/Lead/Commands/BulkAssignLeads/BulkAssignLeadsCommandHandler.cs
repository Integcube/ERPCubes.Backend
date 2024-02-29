using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Industry.Queries.GetIndustryList;
using ERPCubes.Application.Features.Crm.Lead.Commands.BulkAssignLeads;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.BulkAssignLeads
{
    public class BulkAssignLeadsCommandHandler : IRequestHandler<BulkAssignLeadsCommand>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<BulkAssignLeadsCommandHandler> _logger;
        public BulkAssignLeadsCommandHandler(IAsyncLeadRepository leadRepository, ILogger<BulkAssignLeadsCommandHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(BulkAssignLeadsCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _leadRepository.BulkAssignLeads(request);
            }
            catch(Exception ex)
            {
                _logger.LogError($"Deleting bulk leads {request.Leads} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;

        }
    }
}
