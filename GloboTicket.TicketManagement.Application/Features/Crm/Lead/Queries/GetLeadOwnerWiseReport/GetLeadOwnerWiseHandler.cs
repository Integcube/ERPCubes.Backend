using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadOwnerWiseReport
{
    public class GetLeadOwnerWiseHandler : IRequestHandler<GetLeadOwnerWiseQuery, List<GetLeadOwnerWiseVm>>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetLeadOwnerWiseHandler> _logger;
        public GetLeadOwnerWiseHandler(IAsyncLeadRepository leadRepository, ILogger<GetLeadOwnerWiseHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }
        public async Task<List<GetLeadOwnerWiseVm>> Handle(GetLeadOwnerWiseQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetLeadOwnerWiseVm> LeadOwnerWiseReport = new List<GetLeadOwnerWiseVm>();
                LeadOwnerWiseReport = await _leadRepository.GetLeadOwnerWise(request.TenantId, request.Id, request.startDate, request.endDate, request.leadOwner, request.sourceId, request.status);
                return LeadOwnerWiseReport;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Owner Wise list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
