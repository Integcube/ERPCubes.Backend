using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Email.Queries.GetEmailList
{
    public class GetEmailListQueryHandler : IRequestHandler<GetEmailListQuery, List<GetEmailVm>>
    {
        private readonly IAsyncEmailRepository _emailRepository;
        private readonly ILogger<GetEmailListQueryHandler> _logger;
        public GetEmailListQueryHandler(IAsyncEmailRepository emailRepository, ILogger<GetEmailListQueryHandler> logger)
        {
            _emailRepository = emailRepository;
            _logger = logger;
        }
        public async Task<List<GetEmailVm>> Handle(GetEmailListQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetEmailVm> Emails = new List<GetEmailVm>();
                Emails = await _emailRepository.GetAllList(request.Id, request.TenantId, request.LeadId, request.CompanyId, request.OpportunityId);
                return Emails;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Task List failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
