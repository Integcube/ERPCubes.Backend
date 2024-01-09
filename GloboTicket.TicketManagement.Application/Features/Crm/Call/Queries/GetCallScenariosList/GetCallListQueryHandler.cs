using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Call.Queries.GetCallScenariosList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ERPCubes.Application.Features.Crm.Call.Queries.GetCallScenariosList
{
    public class GetCallListQueryHandler : IRequestHandler<GetCallScenariosListListQuery, List<GetCallScenariosVm>>
    {
        private readonly IAsyncCallRepository _callRepository;
        private readonly ILogger<GetCallListQueryHandler> _logger;
        public GetCallListQueryHandler(IAsyncCallRepository callRepository, ILogger<GetCallListQueryHandler> logger)
        {
            _callRepository = callRepository;
            _logger = logger;
        }
        public async Task<List<GetCallScenariosVm>> Handle(GetCallScenariosListListQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetCallScenariosVm> Calls = new List<GetCallScenariosVm>();
                Calls = await _callRepository.ScenariosList();
                return Calls;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Calls List failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
