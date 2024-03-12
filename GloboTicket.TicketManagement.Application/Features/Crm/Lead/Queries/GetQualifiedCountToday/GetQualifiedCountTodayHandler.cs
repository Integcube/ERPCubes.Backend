using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLostCountToday;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetQualifiedCountToday
{
    public class GetQualifiedCountTodayHandler : IRequestHandler<GetQualifiedCountTodayQuery, GetQualifiedCountTodayVm>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetQualifiedCountTodayHandler> _logger;
        public GetQualifiedCountTodayHandler(IAsyncLeadRepository leadRepository, ILogger<GetQualifiedCountTodayHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<GetQualifiedCountTodayVm> Handle(GetQualifiedCountTodayQuery request, CancellationToken cancellationToken)
        {
            try
            {
                GetQualifiedCountTodayVm LeadCount = new GetQualifiedCountTodayVm();
                LeadCount = await _leadRepository.GetQualifiedCountToday(request.TenantId);
                return LeadCount;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Qualified Wise list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
