using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Checklist.Queries.GetChecklists;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.CreateCheckList.Queries.GetCheckpoints
{
    public class GetCheckpointHandler : IRequestHandler<GetCheckpointQuery, List<GetCheckpointsVm>>
    {
        private readonly IAsyncCreateCheckListRepository _checklistRepository;
        private readonly ILogger<GetCheckpointHandler> _logger;

        public GetCheckpointHandler(IAsyncCreateCheckListRepository checklistRepository, ILogger<GetCheckpointHandler> logger)
        {
            _checklistRepository = checklistRepository;
            _logger = logger;
        }

        public async Task<List<GetCheckpointsVm>> Handle(GetCheckpointQuery request, CancellationToken cancellationToken)
        {
            List<GetCheckpointsVm> checklists = new List<GetCheckpointsVm>();
            try
            {
                checklists = await _checklistRepository.GetAllCheckpoint(request.TenantId, request.Id, request.CLId);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting checkpoints list failed due to an error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return checklists;
        }
    }
}
