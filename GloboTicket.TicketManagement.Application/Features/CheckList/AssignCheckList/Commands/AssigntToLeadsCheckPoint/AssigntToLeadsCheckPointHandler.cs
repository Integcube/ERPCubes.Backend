using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.AssignCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.AssigntToLeadsCheckPoint;
using ERPCubes.Application.Features.Crm.Email.Commands.SaveEmail;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Application.Features.CheckList.AssignCheckList.Commands.AssigntToLeadsCheckPoint
{
    public class AssigntToLeadsCheckPointHandler : IRequestHandler<AssigntToLeadsCheckPointCommand>
    {
        private readonly IAsyncAssignCheckListRepository _callRepository;
        private readonly ILogger<AssignCheckPointCommand> _logger;

        public AssigntToLeadsCheckPointHandler(IAsyncAssignCheckListRepository callRepository, ILogger<AssignCheckPointCommand> logger)
        {
            _callRepository = callRepository;
            _logger = logger;
        }
    
        public async Task<Unit> Handle(AssigntToLeadsCheckPointCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _callRepository.AssignToLeads(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"assigning assignchecklist {request.CLId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);

            }
            return Unit.Value;
        }
    }
}
