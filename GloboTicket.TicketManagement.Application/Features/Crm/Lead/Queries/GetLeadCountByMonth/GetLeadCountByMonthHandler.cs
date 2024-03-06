using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountByOwner;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountByMonth
{
    public class GetLeadCountByMonthHandler : IRequestHandler<GetLeadCountByMonthQuery, List<GetLeadCountByMonthVm>>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetLeadCountByMonthHandler> _logger;
        public GetLeadCountByMonthHandler(IAsyncLeadRepository leadRepository, ILogger<GetLeadCountByMonthHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<List<GetLeadCountByMonthVm>> Handle(GetLeadCountByMonthQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetLeadCountByMonthVm> LeadCountByMonth = new List<GetLeadCountByMonthVm>();
                LeadCountByMonth = await _leadRepository.GetLeadCountByMonth(request.TenantId);
                return LeadCountByMonth;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Month Wise list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
