using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Task.Commands.DeleteTask;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Commands.RestoreTasks
{
    public class RestoreTaskCommandHandler : IRequestHandler<RestoreTaskCommand>
    {
        private readonly IAsyncTaskRepository _taskRepository;
        private readonly ILogger<RestoreTaskCommandHandler> _logger;
        public RestoreTaskCommandHandler(IAsyncTaskRepository taskRepository, ILogger<RestoreTaskCommandHandler> logger)
        {
            _taskRepository = taskRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(RestoreTaskCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _taskRepository.RestoreTask(request);
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
