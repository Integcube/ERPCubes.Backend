using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Industry.Queries.GetIndustryList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


    namespace ERPCubes.Application.Features.CheckList.ExecuteCheckList.Queries.SetStatus

{
    public class SetStatusCommandHandler : IRequestHandler<SetStatusCommand>
    {
        private readonly IAsyncExecuteCheckListRepository _leadRepository;
        private readonly ILogger<SetStatusCommandHandler> _logger;
        public SetStatusCommandHandler(IAsyncExecuteCheckListRepository leadRepository, ILogger<SetStatusCommandHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SetStatusCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _leadRepository.SetStatus(request);
            }
            catch(Exception ex)
            {
                _logger.LogError($"change status checklist {request.ExecId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;

        }
    }
}
