using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Tags.Commands.DeleteTags;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Commands.DeleteTask
{
    public class DeleteTaskCommandHandler : IRequestHandler<DeleteTaskCommand>
    {
        private readonly IAsyncTaskRepository _taskRepository;
        private readonly ILogger<DeleteTaskCommandHandler> _logger;
        public DeleteTaskCommandHandler(IAsyncTaskRepository taskRepository, ILogger<DeleteTaskCommandHandler> logger)
        {
            _taskRepository = taskRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(DeleteTaskCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _taskRepository.DeletTask(request);
                return Unit.Value;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting Task :{request.TaskTitle} failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
