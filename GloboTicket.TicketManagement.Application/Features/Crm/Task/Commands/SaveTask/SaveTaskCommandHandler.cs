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

namespace ERPCubes.Application.Features.Crm.Task.Commands.SaveTask
{
    public class SaveTaskCommandHandler : IRequestHandler<SaveTaskCommand>
    {
        private readonly IAsyncTaskRepository _taskRepository;
        private readonly ILogger<SaveTaskCommandHandler> _logger;
        public SaveTaskCommandHandler(IAsyncTaskRepository taskRepository, ILogger<SaveTaskCommandHandler> logger)
        {
            _taskRepository = taskRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveTaskCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _taskRepository.SaveTask(request);
                return Unit.Value;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving Task :{request.Task.TaskTitle} failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
