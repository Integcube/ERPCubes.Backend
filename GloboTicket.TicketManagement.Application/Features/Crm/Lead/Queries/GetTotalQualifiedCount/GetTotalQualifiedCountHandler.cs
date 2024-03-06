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

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalQualifiedCount
{
    public class GetTotalQualifiedCountHandler : IRequestHandler<GetTotalQualifiedCountQuery, GetTotalQualifiedCountVm>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetTotalQualifiedCountHandler> _logger;
        public GetTotalQualifiedCountHandler(IAsyncLeadRepository leadRepository, ILogger<GetTotalQualifiedCountHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<GetTotalQualifiedCountVm> Handle(GetTotalQualifiedCountQuery request, CancellationToken cancellationToken)
        {
            try
            {
                GetTotalQualifiedCountVm LeadCount = new GetTotalQualifiedCountVm();
                LeadCount = await _leadRepository.GetQualifiedLeadCount(request.TenantId);
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
