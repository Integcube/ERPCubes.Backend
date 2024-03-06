using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadOwnerWiseReport;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountByOwner
{
    public class GetLeadCountByOwnerHandler : IRequestHandler<GetLeadCountByOwnerQuery, List<GetLeadCountByOwnerVm>>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetLeadCountByOwnerHandler> _logger;
        public GetLeadCountByOwnerHandler(IAsyncLeadRepository leadRepository, ILogger<GetLeadCountByOwnerHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }

        public async Task<List<GetLeadCountByOwnerVm>> Handle(GetLeadCountByOwnerQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetLeadCountByOwnerVm> LeadCountByOwner = new List<GetLeadCountByOwnerVm>();
                LeadCountByOwner = await _leadRepository.GetLeadCountByOwner(request.TenantId);
                return LeadCountByOwner;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Owner Wise list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
