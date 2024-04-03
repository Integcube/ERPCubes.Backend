using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Checklist.Queries.CheckListReport
{
    public class CheckListReportHandler : IRequestHandler<CheckListReportQuery, List<CheckListReportVm>>
    {
        private readonly IAsyncCheckListReportRepository _checklistRepository;
        private readonly ILogger<CheckListReportHandler> _logger;

        public CheckListReportHandler(IAsyncCheckListReportRepository checklistRepository, ILogger<CheckListReportHandler> logger)
        {
            _checklistRepository = checklistRepository;
            _logger = logger;
        }

        public async Task<List<CheckListReportVm>> Handle(CheckListReportQuery request, CancellationToken cancellationToken)
        {
            List<CheckListReportVm> checklists = new List<CheckListReportVm>();
            try
            {
                checklists = await _checklistRepository.CheckListReport(request);
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
