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

namespace ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskStatus
{
    public class UpdateTaskStatusCommandHandler : IRequestHandler<UpdateTaskStatusCommand>
    {
        private readonly IAsyncTaskRepository _taskRepository;
        private readonly ILogger<UpdateTaskStatusCommandHandler> _logger;
        public UpdateTaskStatusCommandHandler(IAsyncTaskRepository taskRepository, ILogger<UpdateTaskStatusCommandHandler> logger)
        {
            _taskRepository = taskRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(UpdateTaskStatusCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _taskRepository.UpdateTaskStatus(request);
                return Unit.Value;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Updating Task :{request.TaskTitle} failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
