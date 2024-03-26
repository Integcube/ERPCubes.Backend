using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Checklist.Command.SaveChecklist;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.ExecuteCheckList.Commands.GetAssignedCheckList
{
    public class GetAssignedCheckListQueryHandler : IRequestHandler<GetAssignedCheckListQuery, List<GetAssignedCheckListVm>>
    {
        private readonly IAsyncExecuteCheckListRepository _checklistRepository;
        private readonly ILogger<GetAssignedCheckListQueryHandler> _logger;

        public GetAssignedCheckListQueryHandler(IAsyncExecuteCheckListRepository checklistRepository, ILogger<GetAssignedCheckListQueryHandler> logger)
        {
            _checklistRepository = checklistRepository;
            _logger = logger;
        }

        public async Task<List<GetAssignedCheckListVm>> Handle(GetAssignedCheckListQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetAssignedCheckListVm> user = await _checklistRepository.GetAssignedCheckList(request);
                return user;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Checklist to execute failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
