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

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetleadPiplineReport
{
    public class GetleadPiplineReportQueryHandler : IRequestHandler<GetleadPiplineReportQuery, List<GetleadPiplineReportVm>>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetleadPiplineReportQueryHandler> _logger;
        public GetleadPiplineReportQueryHandler(IAsyncLeadRepository leadRepository, ILogger<GetleadPiplineReportQueryHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }
        public async Task<List<GetleadPiplineReportVm>> Handle(GetleadPiplineReportQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetleadPiplineReportVm> LeadReport = new List<GetleadPiplineReportVm>();
                LeadReport = await _leadRepository.GetleadPiplineReport(request);
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
