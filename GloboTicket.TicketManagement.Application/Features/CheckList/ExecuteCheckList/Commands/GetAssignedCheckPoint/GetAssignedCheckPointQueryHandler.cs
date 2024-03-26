using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.CheckList.ExecuteCheckList.Commands.GetAssignedCheckList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.ExecuteCheckList.Commands.GetAssignedCheckPoint
{
    public class GetAssignedCheckPointQueryHandler : IRequestHandler<GetAssignedCheckPointQuery, List<GetAssignedCheckPointVm>>
    {
        private readonly IAsyncExecuteCheckListRepository _checklistRepository;
        private readonly ILogger<GetAssignedCheckPointQueryHandler> _logger;

        public GetAssignedCheckPointQueryHandler(IAsyncExecuteCheckListRepository checklistRepository, ILogger<GetAssignedCheckPointQueryHandler> logger)
        {
            _checklistRepository = checklistRepository;
            _logger = logger;
        }

        public async Task<List<GetAssignedCheckPointVm>> Handle(GetAssignedCheckPointQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetAssignedCheckPointVm> checkpoint = await _checklistRepository.GetAssignedCheckPoint(request);
                return checkpoint;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Checklist to execute failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
