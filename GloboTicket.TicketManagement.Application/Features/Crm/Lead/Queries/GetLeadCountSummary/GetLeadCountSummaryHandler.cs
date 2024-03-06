using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalWonCount;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountSummary
{
    public class GetLeadCountSummaryHandler : IRequestHandler<GetLeadCountSummaryQuery, GetLeadCountSummaryVm>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetLeadCountSummaryHandler> _logger;
        public GetLeadCountSummaryHandler(IAsyncLeadRepository leadRepository, ILogger<GetLeadCountSummaryHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<GetLeadCountSummaryVm> Handle(GetLeadCountSummaryQuery request, CancellationToken cancellationToken)
        {
            try
            {
                GetLeadCountSummaryVm LeadCount = new GetLeadCountSummaryVm();
                LeadCount = await _leadRepository.GetLeadCountSummary(request.TenantId);
                return LeadCount;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Summary list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
