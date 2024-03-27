using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Industry.Queries.GetIndustryList;
using ERPCubes.Application.Features.Crm.Lead.Commands.SetStatus;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


    namespace ERPCubes.Application.Features.CheckList.ExecuteCheckList.Queries.SetStatus

{
    public class SetCheckPointStatusCommandHandler : IRequestHandler<SetCheckPointStatusCommand>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<SetCheckPointStatusCommandHandler> _logger;
        public SetCheckPointStatusCommandHandler(IAsyncLeadRepository leadRepository, ILogger<SetCheckPointStatusCommandHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SetCheckPointStatusCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _leadRepository.SetCheckPointStatus(request);
            }
            catch(Exception ex)
            {
                _logger.LogError($"change status checklist {request.CpId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;

        }
    }
}
