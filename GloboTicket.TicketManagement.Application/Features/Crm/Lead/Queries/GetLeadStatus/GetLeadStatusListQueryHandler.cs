using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadStatus
{
    public class GetLeadStatusListQueryHandler : IRequestHandler<GetLeadStatusListQuery, List<GetLeadStatusListVm>>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetLeadStatusListQueryHandler> _logger;
        public GetLeadStatusListQueryHandler(IAsyncLeadRepository leadRepository, ILogger<GetLeadStatusListQueryHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<List<GetLeadStatusListVm>> Handle(GetLeadStatusListQuery request, CancellationToken cancellationToken)
        {
            List<GetLeadStatusListVm> statusList = new List<GetLeadStatusListVm>();
            try
            {
                statusList = await _leadRepository.GetAllLeadStatus(request.TenantId, request.Id);
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
