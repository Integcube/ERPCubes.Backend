using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.AssignCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.AssigntToLeadsCheckPoint;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.UnassignToLeadsCheckPoint
{
    public class UnassignToLeadsCheckPointHandler : IRequestHandler<UnassignToLeadsCheckPointCommand>
    {
        private readonly IAsyncAssignCheckListRepository _callRepository;
        private readonly ILogger<UnassignToLeadsCheckPointCommand> _logger;

        public UnassignToLeadsCheckPointHandler(IAsyncAssignCheckListRepository callRepository, ILogger<UnassignToLeadsCheckPointCommand> logger)
        {
            _callRepository = callRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(UnassignToLeadsCheckPointCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _callRepository.UnassignToLeads(request);
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
