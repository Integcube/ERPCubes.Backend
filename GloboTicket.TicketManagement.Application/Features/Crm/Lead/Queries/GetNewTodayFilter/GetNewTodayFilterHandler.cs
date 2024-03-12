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

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetNewTodayFilter
{
    public class GetNewTodayFilterHandler : IRequestHandler<GetNewTodayFilterQuery, GetNewTodayFilterVm>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetNewTodayFilterHandler> _logger;
        public GetNewTodayFilterHandler(IAsyncLeadRepository leadRepository, ILogger<GetNewTodayFilterHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<GetNewTodayFilterVm> Handle(GetNewTodayFilterQuery request, CancellationToken cancellationToken)
        {
            try
            {
                GetNewTodayFilterVm LeadCount = new GetNewTodayFilterVm();
                LeadCount = await _leadRepository.GetNewTodayFilter(request.TenantId);
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
