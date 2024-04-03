using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Checklist.Queries.CheckListReport;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.ChecklistReports.Queries.ExecutedLeadChecklistReport
{
    public class ExecutedLeadChecklistReportHandler : IRequestHandler<ExecutedLeadChecklistReportQuery, List<ExecutedLeadChecklistReportVm>>
    {
        private readonly IAsyncCheckListReportRepository _checklistRepository;
        private readonly ILogger<ExecutedLeadChecklistReportHandler> _logger;

        public ExecutedLeadChecklistReportHandler(IAsyncCheckListReportRepository checklistRepository, ILogger<ExecutedLeadChecklistReportHandler> logger)
        {
            _checklistRepository = checklistRepository;
            _logger = logger;
        }

        public async Task<List<ExecutedLeadChecklistReportVm>> Handle(ExecutedLeadChecklistReportQuery request, CancellationToken cancellationToken)
        {
            List<ExecutedLeadChecklistReportVm> checklists = new List<ExecutedLeadChecklistReportVm>();
            try
            {
                checklists = await _checklistRepository.ExecutedLeadCheckListReport(request.TenantId, request.startDate, request.endDate);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting checklists list failed due to an error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return checklists;
        }
    }
}
