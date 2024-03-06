using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountByMonth;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalLeadCount
{
    public class GetTotalLeadCountHandler : IRequestHandler<GetTotalLeadCountQuery, GetTotalLeadCountVm>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetTotalLeadCountHandler> _logger;
        public GetTotalLeadCountHandler(IAsyncLeadRepository leadRepository, ILogger<GetTotalLeadCountHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<GetTotalLeadCountVm> Handle(GetTotalLeadCountQuery request, CancellationToken cancellationToken)
        {
            try
            {
                GetTotalLeadCountVm LeadCountByMonth = new GetTotalLeadCountVm();
                LeadCountByMonth = await _leadRepository.GetTotalLeadCount(request.TenantId);
                return LeadCountByMonth;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Total Wise list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
