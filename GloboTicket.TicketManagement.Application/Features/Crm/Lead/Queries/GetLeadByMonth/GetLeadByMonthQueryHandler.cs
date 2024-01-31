using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadReport;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadByMonth
{
    public class GetLeadByMonthQueryHandler : IRequestHandler<GetLeadByMonthListQuery, List<GetLeadByMonthListVm>>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetLeadByMonthQueryHandler> _logger;
        public GetLeadByMonthQueryHandler(IAsyncLeadRepository leadRepository, ILogger<GetLeadByMonthQueryHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<List<GetLeadByMonthListVm>> Handle(GetLeadByMonthListQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetLeadByMonthListVm> LeadByMonth = new List<GetLeadByMonthListVm>();
                LeadByMonth = await _leadRepository.GetLeadByMonth(request.TenantId, request.Id, request.ProductId, request.SourceId, request.UserId, request.Year);
                return LeadByMonth;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Status list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
