using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadStatus;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetStatusWiseLeads
{
    public class GetStatusWiseLeadsQueryHander : IRequestHandler<GetStatusWiseLeadsQuery, List<GetStatusWiseLeadsVm>>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetLeadStatusListQueryHandler> _logger;
        public GetStatusWiseLeadsQueryHander(IAsyncLeadRepository leadRepository, ILogger<GetLeadStatusListQueryHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<List<GetStatusWiseLeadsVm>> Handle(GetStatusWiseLeadsQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetStatusWiseLeadsVm> statusWiseLeadsList = await _leadRepository.GetStatusWiseLeads(request);
                return statusWiseLeadsList;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Status list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
