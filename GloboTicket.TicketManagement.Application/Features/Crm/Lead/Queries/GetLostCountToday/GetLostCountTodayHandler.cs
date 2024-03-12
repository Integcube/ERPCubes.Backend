using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLostCountFilter;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLostCountToday
{
    public class GetLostCountTodayHandler : IRequestHandler<GetLostCountTodayQuery, GetLostCountTodayVm>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetLostCountTodayHandler> _logger;
        public GetLostCountTodayHandler(IAsyncLeadRepository leadRepository, ILogger<GetLostCountTodayHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<GetLostCountTodayVm> Handle(GetLostCountTodayQuery request, CancellationToken cancellationToken)
        {
            try
            {
                GetLostCountTodayVm LeadCount = new GetLostCountTodayVm();
                LeadCount = await _leadRepository.GetLostCountToday(request.TenantId);
                return LeadCount;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Lost Wise list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
