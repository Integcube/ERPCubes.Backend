using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Task.Commands.SaveTask;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Commands.UpdateTaskOrder
{
    public class UpdateTaskOrderCommandHandler : IRequestHandler<UpdateTaskOrderCommand>
    {
        private readonly IAsyncTaskRepository _taskRepository;
        private readonly ILogger<UpdateTaskOrderCommandHandler> _logger;
        public UpdateTaskOrderCommandHandler(IAsyncTaskRepository taskRepository, ILogger<UpdateTaskOrderCommandHandler> logger)
        {
            _taskRepository = taskRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(UpdateTaskOrderCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _taskRepository.UpdateTaskOrder(request.Tasks);
                return Unit.Value;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Updating Task Order  failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
