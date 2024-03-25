using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Checklist.Queries.GetChecklists;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Checklist.Command.SaveChecklist
{
    public class SaveChecklistHandler : IRequestHandler<SaveChecklistCommand>
    {
        private readonly IAsyncCreateCheckListRepository _checklistRepository;
        private readonly ILogger<SaveChecklistHandler> _logger;

        public SaveChecklistHandler(IAsyncCreateCheckListRepository checklistRepository, ILogger<SaveChecklistHandler> logger)
        {
            _checklistRepository = checklistRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(SaveChecklistCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _checklistRepository.SaveChecklist(request);
                return Unit.Value;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving Checklist :{request.Checklist.Title} failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
