using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSource;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadStatus;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadReport
{
    public class GetLeadReportQueryHandler : IRequestHandler<GetLeadReportQuery, List<GetLeadReportVm>>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetLeadReportQueryHandler> _logger;
        public GetLeadReportQueryHandler(IAsyncLeadRepository leadRepository, ILogger<GetLeadReportQueryHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }
        public async Task<List<GetLeadReportVm>> Handle(GetLeadReportQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetLeadReportVm> LeadReport = new List<GetLeadReportVm>();
                LeadReport = await _leadRepository.GetLeadReport(request.TenantId, request.Id, request.startDate, request.endDate, request.prodId);
                return LeadReport;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Status list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
