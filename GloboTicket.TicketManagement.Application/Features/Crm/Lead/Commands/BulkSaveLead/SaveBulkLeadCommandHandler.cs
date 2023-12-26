using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Commands.DeleteLead;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.BulkSaveLead
{
    public class SaveBulkLeadCommandHandler : IRequestHandler<SaveBulkLeadCommand>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<SaveBulkLeadCommandHandler> _logger;
        public SaveBulkLeadCommandHandler(IAsyncLeadRepository leadRepository, ILogger<SaveBulkLeadCommandHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveBulkLeadCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _leadRepository.SaveLeadBulk(request);
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
