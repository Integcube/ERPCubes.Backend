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

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSource
{
    public class GetLeadSourceListQueryHandler : IRequestHandler<GetLeadSourceListQuery, List<GetLeadSourceListVm>>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetLeadSourceListQueryHandler> _logger;
        public GetLeadSourceListQueryHandler(IAsyncLeadRepository leadRepository, ILogger<GetLeadSourceListQueryHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }
        public async Task<List<GetLeadSourceListVm>> Handle(GetLeadSourceListQuery request, CancellationToken cancellationToken)
        {
            List<GetLeadSourceListVm> SourceList = new List<GetLeadSourceListVm>();
            try
            {
                SourceList = await _leadRepository.GetAllLeadSource(request.TenantId, request.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Status list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return SourceList;
        }
    }
}
