using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalLostCount;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalWonCount
{
    public class GetTotalWonCountHandler : IRequestHandler<GetTotalWonCountQuery, GetTotalWonCountVm>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetTotalWonCountHandler> _logger;
        public GetTotalWonCountHandler(IAsyncLeadRepository leadRepository, ILogger<GetTotalWonCountHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<GetTotalWonCountVm> Handle(GetTotalWonCountQuery request, CancellationToken cancellationToken)
        {
            try
            {
                GetTotalWonCountVm LeadCount = new GetTotalWonCountVm();
                LeadCount = await _leadRepository.GetWonLeadCount(request.TenantId);
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
