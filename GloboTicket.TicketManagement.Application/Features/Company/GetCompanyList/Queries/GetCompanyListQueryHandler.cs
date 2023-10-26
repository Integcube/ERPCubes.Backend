using ERPCubes.Application.Contracts.Persistence.CRM;
using MediatR;

namespace ERPCubes.Application.Features.Company.GetCompanyList.Queries
{
    public class GetCompanyListQueryHandler : IRequestHandler<GetCompanyListQuery, List<GetCompanyVm>>
    {
        private readonly IAsyncCompanyRepository _companyRepository;

        public GetCompanyListQueryHandler(IAsyncCompanyRepository companyRepository)
        {
            _companyRepository = companyRepository;
        }
        public async Task<List<GetCompanyVm>> Handle(GetCompanyListQuery request, CancellationToken cancellationToken)
        {
            var companies = await _companyRepository.GetAllList(request.Id, request.TenantId);
            return companies;
        }
    }
}
