using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountByMonth;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSourceByCount
{
    public class GetLeadSourceByCountHandler : IRequestHandler<GetLeadSourceByCountQuery, List<GetLeadSourceByCountVm>>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetLeadSourceByCountHandler> _logger;
        public GetLeadSourceByCountHandler(IAsyncLeadRepository leadRepository, ILogger<GetLeadSourceByCountHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<List<GetLeadSourceByCountVm>> Handle(GetLeadSourceByCountQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetLeadSourceByCountVm> LeadCountByMonth = new List<GetLeadSourceByCountVm>();
                LeadCountByMonth = await _leadRepository.GetLeadSourceByCount(request.TenantId);
                return LeadCountByMonth;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Source Wise list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
