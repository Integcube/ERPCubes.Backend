using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetNewCountFilter;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetQualifiedCountFilter
{
    public class GetQualifiedCountFilterHandler : IRequestHandler<GetQualifiedCountFilterQuery, GetQualifiedCountFilterVm>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetQualifiedCountFilterHandler> _logger;
        public GetQualifiedCountFilterHandler(IAsyncLeadRepository leadRepository, ILogger<GetQualifiedCountFilterHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<GetQualifiedCountFilterVm> Handle(GetQualifiedCountFilterQuery request, CancellationToken cancellationToken)
        {
            try
            {
                GetQualifiedCountFilterVm LeadCount = new GetQualifiedCountFilterVm();
                LeadCount = await _leadRepository.GetQualifiedCountFilter(request.TenantId, request.daysAgo);
                return LeadCount;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Qualified Wise list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
