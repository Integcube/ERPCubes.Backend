using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskStatus;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskPriority
{
    public class UpdateTaskPriorityCommandHandler : IRequestHandler<UpdateTaskPriorityCommand>
    {
        private readonly IAsyncTaskRepository _taskRepository;
        private readonly ILogger<UpdateTaskPriorityCommandHandler> _logger;
        public UpdateTaskPriorityCommandHandler(IAsyncTaskRepository taskRepository, ILogger<UpdateTaskPriorityCommandHandler> logger)
        {
            _taskRepository = taskRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(UpdateTaskPriorityCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _taskRepository.UpdateTaskPriority(request);
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
