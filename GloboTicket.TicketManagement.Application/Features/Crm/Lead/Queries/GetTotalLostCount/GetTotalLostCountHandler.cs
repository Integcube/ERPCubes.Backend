using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalQualifiedCount;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetTotalLostCount
{
    public class GetTotalLostCountHandler : IRequestHandler<GetTotalLostCountQuery, GetTotalLostCountVm>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetTotalLostCountHandler> _logger;
        public GetTotalLostCountHandler(IAsyncLeadRepository leadRepository, ILogger<GetTotalLostCountHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<GetTotalLostCountVm> Handle(GetTotalLostCountQuery request, CancellationToken cancellationToken)
        {
            try
            {
                GetTotalLostCountVm LeadCount = new GetTotalLostCountVm();
                LeadCount = await _leadRepository.GetLostLeadCount(request.TenantId);
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
