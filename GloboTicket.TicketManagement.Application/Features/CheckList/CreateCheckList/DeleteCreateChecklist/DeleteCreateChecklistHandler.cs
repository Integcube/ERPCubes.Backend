using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Checklist.Command.SaveChecklist;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.CreateCheckList.DeleteCreateChecklist
{
    public class DeleteCreateChecklistHandler : IRequestHandler<DeleteCreateChecklistCommand>
    {
        private readonly IAsyncCreateCheckListRepository _checklistRepository;
        private readonly ILogger<DeleteCreateChecklistHandler> _logger;

        public DeleteCreateChecklistHandler(IAsyncCreateCheckListRepository checklistRepository, ILogger<DeleteCreateChecklistHandler> logger)
        {
            _checklistRepository = checklistRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(DeleteCreateChecklistCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _checklistRepository.Delete(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting assign checklist {request.CLId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
    
}
