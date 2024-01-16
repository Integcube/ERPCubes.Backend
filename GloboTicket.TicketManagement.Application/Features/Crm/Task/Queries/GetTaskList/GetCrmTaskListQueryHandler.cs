using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Queries.GetTaskList
{

    public class GetCrmTaskListQueryHandler : IRequestHandler<GetCrmTaskListQuery, List<GetCrmTaskListVm>>
    {
        private readonly IAsyncTaskRepository _taskRepository;
        private readonly ILogger<GetCrmTaskListQueryHandler> _logger;
        public GetCrmTaskListQueryHandler(IAsyncTaskRepository taskRepository, ILogger<GetCrmTaskListQueryHandler> logger)
        {
            _taskRepository = taskRepository;
            _logger = logger;
        }
        public async Task<List<GetCrmTaskListVm>> Handle(GetCrmTaskListQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetCrmTaskListVm> Tasks = new List<GetCrmTaskListVm>();
                Tasks = await _taskRepository.GetAllTasks(request.TenantId, request.Id, request.ContactTypeId, request.ContactId);
                return Tasks;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Task List failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
