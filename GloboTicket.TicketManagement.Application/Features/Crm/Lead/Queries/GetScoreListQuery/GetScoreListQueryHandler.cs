using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetScoreListQuery;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetScoreListQuery
{
    public class GetScoreListQueryHandler : IRequestHandler<GetScoreListQuery, List<GetScoreListVm>>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetScoreListQueryHandler> _logger;
        public GetScoreListQueryHandler(IAsyncLeadRepository leadRepository, ILogger<GetScoreListQueryHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<List<GetScoreListVm>> Handle(GetScoreListQuery request, CancellationToken cancellationToken)
        {
            List<GetScoreListVm> statusList = new List<GetScoreListVm>();
            try
            {
                statusList = await _leadRepository.GetleadScoreList(request.TenantId, request.LeadId);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Status list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return statusList;
        }
    }
}
