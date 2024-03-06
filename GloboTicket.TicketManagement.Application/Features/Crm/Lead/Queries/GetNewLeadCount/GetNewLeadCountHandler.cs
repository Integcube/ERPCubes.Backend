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

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetNewLeadCount
{
    public class GetNewLeadCountHandler : IRequestHandler<GetNewLeadCountQuery, GetNewLeadCountVm>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetNewLeadCountHandler> _logger;
        public GetNewLeadCountHandler(IAsyncLeadRepository leadRepository, ILogger<GetNewLeadCountHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<GetNewLeadCountVm> Handle(GetNewLeadCountQuery request, CancellationToken cancellationToken)
        {
            try
            {
                GetNewLeadCountVm LeadCountByMonth = new GetNewLeadCountVm();
                LeadCountByMonth = await _leadRepository.GetNewLeadCount(request.TenantId);
                return LeadCountByMonth;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead New Wise list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
