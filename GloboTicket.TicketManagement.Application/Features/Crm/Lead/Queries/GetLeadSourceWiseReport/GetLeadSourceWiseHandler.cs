using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Activity.Queries.GetUserActivityReport;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadReport;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSourceWiseReport
{
    public class GetLeadSourceWiseHandler : IRequestHandler<GetLeadSourceWiseQuery, List<GetLeadSourceWiseVm>>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetLeadSourceWiseHandler> _logger;
        public GetLeadSourceWiseHandler(IAsyncLeadRepository leadRepository, ILogger<GetLeadSourceWiseHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }
        public async Task<List<GetLeadSourceWiseVm>> Handle(GetLeadSourceWiseQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetLeadSourceWiseVm> LeadSourceWiseReport = new List<GetLeadSourceWiseVm>();
                LeadSourceWiseReport = await _leadRepository.GetLeadSourceWise(request.TenantId, request.Id, request.startDate, request.endDate, request.sourceId);
                return LeadSourceWiseReport;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Status list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
