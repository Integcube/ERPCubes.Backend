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

namespace ERPCubes.Application.Features.Crm.Checklist.Queries.GetChecklists
{
    public class GetChecklistHandler : IRequestHandler<GetChecklistQuery, List<GetChecklistVm>>
    {
        private readonly IAsyncCreateCheckListRepository _checklistRepository;
        private readonly ILogger<GetChecklistHandler> _logger;

        public GetChecklistHandler(IAsyncCreateCheckListRepository checklistRepository, ILogger<GetChecklistHandler> logger)
        {
            _checklistRepository = checklistRepository;
            _logger = logger;
        }

        public async Task<List<GetChecklistVm>> Handle(GetChecklistQuery request, CancellationToken cancellationToken)
        {
            List<GetChecklistVm> checklists = new List<GetChecklistVm>();
            try
            {
                checklists = await _checklistRepository.GetAllChecklist(request.TenantId, request.Id);
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
