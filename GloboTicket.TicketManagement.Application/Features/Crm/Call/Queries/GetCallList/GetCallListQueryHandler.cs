using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ERPCubes.Application.Features.Crm.Call.Queries.GetCallList
{
    public class GetCallListQueryHandler : IRequestHandler<GetCallListQuery, List<GetCallVm>>
    {
        private readonly IAsyncCallRepository _callRepository;
        private readonly ILogger<GetCallListQueryHandler> _logger;
        public GetCallListQueryHandler(IAsyncCallRepository callRepository, ILogger<GetCallListQueryHandler> logger)
        {
            _callRepository = callRepository;
            _logger = logger;
        }
        public async Task<List<GetCallVm>> Handle(GetCallListQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetCallVm> Calls = new List<GetCallVm>();
                Calls = await _callRepository.GetAllList(request.Id, request.TenantId);
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
