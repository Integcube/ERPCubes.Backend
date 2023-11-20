using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Domain.Entities;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ERPCubes.Application.Features.Crm.Company.Queries.GetCompanyList
{
    public class GetCompanyListQueryHandler : IRequestHandler<GetCompanyListQuery, List<GetCompanyVm>>
    {
        private readonly IAsyncCompanyRepository _companyRepository;
        private readonly ILogger<GetCompanyListQueryHandler> _logger;

        public GetCompanyListQueryHandler(IAsyncCompanyRepository companyRepository, ILogger<GetCompanyListQueryHandler> logger)
        {
            _companyRepository = companyRepository;
            _logger = logger;
        }
        public async Task<List<GetCompanyVm>> Handle(GetCompanyListQuery request, CancellationToken cancellationToken)
        {
            List<GetCompanyVm> companies = new List<GetCompanyVm>();
            try
            {
                companies = await _companyRepository.GetAllList(request.Id, request.TenantId);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting about company list failed due to an error: {ex.Message}");
            }
            return companies;

        }
    }
}
