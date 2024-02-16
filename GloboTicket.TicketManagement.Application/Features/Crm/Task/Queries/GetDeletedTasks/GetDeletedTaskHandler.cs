using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Notes.Queries.GetDeletedNotes;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Queries.GetDeletedTasks
{
    public class GetDeletedTaskHandler : IRequestHandler<GetDeletedTaskQuery, List<GetDeletedTaskVm>>
    {
        private readonly IAsyncTaskRepository _taskRepository;
        private readonly ILogger<GetDeletedTaskHandler> _logger;

        public GetDeletedTaskHandler(IAsyncTaskRepository taskRepository, ILogger<GetDeletedTaskHandler> logger)
        {
            _taskRepository = taskRepository;
            _logger = logger;
        }

        public async Task<List<GetDeletedTaskVm>> Handle(GetDeletedTaskQuery request, CancellationToken cancellationToken)
        {
            List<GetDeletedTaskVm> tasks = new List<GetDeletedTaskVm>();
            try
            {
                tasks = await _taskRepository.GetDeletedTask(request.TenantId, request.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting task list failed due to an error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return tasks;
        }
    }
}
