using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Task.Commands.RestoreTasks;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Commands.RestoreBulkTask
{
    public class RestoreBulkTaskCommandHandler : IRequestHandler<RestoreBulkTaskCommand>
    {
        private readonly IAsyncTaskRepository _taskRepository;
        private readonly ILogger<RestoreBulkTaskCommandHandler> _logger;
        public RestoreBulkTaskCommandHandler(IAsyncTaskRepository taskRepository, ILogger<RestoreBulkTaskCommandHandler> logger)
        {
            _taskRepository = taskRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(RestoreBulkTaskCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _taskRepository.RestoreBulkTask(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting task {request.TaskId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
