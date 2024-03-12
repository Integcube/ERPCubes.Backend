using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLostCountFilter;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetWonCountFilter
{
    public class GetWonCountFilterHandler : IRequestHandler<GetWonCountFilterQuery, GetWonCountFilterVm>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetWonCountFilterHandler> _logger;
        public GetWonCountFilterHandler(IAsyncLeadRepository leadRepository, ILogger<GetWonCountFilterHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<GetWonCountFilterVm> Handle(GetWonCountFilterQuery request, CancellationToken cancellationToken)
        {
            try
            {
                GetWonCountFilterVm LeadCount = new GetWonCountFilterVm();
                LeadCount = await _leadRepository.GetWonCountFilter(request.TenantId, request.daysAgo);
                return LeadCount;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Won Wise list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
