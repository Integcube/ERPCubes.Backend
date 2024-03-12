using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalCountFilter;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetNewCountFilter
{
    public class GetNewCountfilterHandler : IRequestHandler<GetNewCountFilterQuery, GetNewCountFilterVm>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetNewCountfilterHandler> _logger;
        public GetNewCountfilterHandler(IAsyncLeadRepository leadRepository, ILogger<GetNewCountfilterHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<GetNewCountFilterVm> Handle(GetNewCountFilterQuery request, CancellationToken cancellationToken)
        {
            try
            {
                GetNewCountFilterVm LeadCount = new GetNewCountFilterVm();
                LeadCount = await _leadRepository.GetNewCountFilter(request.TenantId, request.daysAgo);
                return LeadCount;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead New Wise list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
