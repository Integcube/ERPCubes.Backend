using ERPCubes.Application.Contracts.Persistence.CRM;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.RestoreDeletedLeads
{
    public class RestoreDeletedLeadsCommandHandler: IRequestHandler<RestoreDeletedLeadsCommand>
    {
        private IAsyncLeadRepository _leadRepository;
        private ILogger<RestoreDeletedLeadsCommandHandler> _logger;
        public RestoreDeletedLeadsCommandHandler(IAsyncLeadRepository leadRepository, ILogger<RestoreDeletedLeadsCommandHandler> logger) 
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(RestoreDeletedLeadsCommand request, CancellationToken token)
        {
            try
            {
                await _leadRepository.RestoreDeletedLeads(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"There was a problem restoring Deleted Leads due to: {ex.Message}");
                throw new Exception(ex.Message);
            }
            return Unit.Value;
        }
    }
}
