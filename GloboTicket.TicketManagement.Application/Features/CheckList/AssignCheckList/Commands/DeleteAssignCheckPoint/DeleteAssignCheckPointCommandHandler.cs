using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.DeleteAssignCheckPoint
{
    public class DeleteAssignCheckPointCommandHandler : IRequestHandler<DeleteAssignCheckPointCommand>
    {
        private readonly IAsyncAssignCheckListRepository _calllRepository;
        private readonly ILogger<DeleteAssignCheckPointCommand> _logger;
        public DeleteAssignCheckPointCommandHandler(IAsyncAssignCheckListRepository callRepository, ILogger<DeleteAssignCheckPointCommand> logger)
        {
            _calllRepository = callRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(DeleteAssignCheckPointCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _calllRepository.Delete(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting assign checklist {request.ExecId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
