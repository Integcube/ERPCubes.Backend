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

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLostCountFilter
{
    public class GetLostCountFilterHandler : IRequestHandler<GetLostCountFilterQuery, GetLostCountFilterVm>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetLostCountFilterHandler> _logger;
        public GetLostCountFilterHandler(IAsyncLeadRepository leadRepository, ILogger<GetLostCountFilterHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<GetLostCountFilterVm> Handle(GetLostCountFilterQuery request, CancellationToken cancellationToken)
        {
            try
            {
                GetLostCountFilterVm LeadCount = new GetLostCountFilterVm();
                LeadCount = await _leadRepository.GetLostCountFilter(request.TenantId, request.daysAgo);
                return LeadCount;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Lost Wise list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
