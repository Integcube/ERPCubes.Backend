using ERPCubes.Application.Contracts.Persistence.CRM;
using MediatR;
using MediatR.Pipeline;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetDeletedLeads
{
    public class GetDeletedLeadsQueryHandler: IRequestHandler<GetDeletedLeadsQuery, List<GetDeletedLeadsVm>>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetDeletedLeadsQueryHandler> _logger;
        public GetDeletedLeadsQueryHandler(IAsyncLeadRepository leadRepository, ILogger<GetDeletedLeadsQueryHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<List<GetDeletedLeadsVm>> Handle(GetDeletedLeadsQuery request, CancellationToken token)
        {
            try
            {
                List<GetDeletedLeadsVm> dLeads = new List<GetDeletedLeadsVm>();
                dLeads = await (_leadRepository.GetDeletedLeads(request.TenantId, request.Id));
                return dLeads;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Deleted Leads has failed due to an error : {ex.Message}");
                throw new Exception();
            }
        }
    }
}
