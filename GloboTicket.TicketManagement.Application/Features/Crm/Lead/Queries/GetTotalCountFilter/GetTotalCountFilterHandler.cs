using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalLeadCount;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalCountFilter
{
    public class GetTotalCountFilterHandler : IRequestHandler<GetTotalCountFilterQuery, GetTotalCountFilterVm>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetTotalCountFilterHandler> _logger;
        public GetTotalCountFilterHandler(IAsyncLeadRepository leadRepository, ILogger<GetTotalCountFilterHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<GetTotalCountFilterVm> Handle(GetTotalCountFilterQuery request, CancellationToken cancellationToken)
        {
            try
            {
                GetTotalCountFilterVm LeadCount = new GetTotalCountFilterVm();
                LeadCount = await _leadRepository.GetTotalCountFilter(request.TenantId, request.daysAgo);
                return LeadCount;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Total Wise list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
