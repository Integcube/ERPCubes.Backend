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

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetWonCountToday
{
    public class GetWonCountTodayHandler : IRequestHandler<GetWonCountTodayQuery, GetWonCountTodayVm>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetWonCountTodayHandler> _logger;
        public GetWonCountTodayHandler(IAsyncLeadRepository leadRepository, ILogger<GetWonCountTodayHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<GetWonCountTodayVm> Handle(GetWonCountTodayQuery request, CancellationToken cancellationToken)
        {
            try
            {
                GetWonCountTodayVm LeadCount = new GetWonCountTodayVm();
                LeadCount = await _leadRepository.GetWonCountToday(request.TenantId);
                return LeadCount;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Count Wise list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
