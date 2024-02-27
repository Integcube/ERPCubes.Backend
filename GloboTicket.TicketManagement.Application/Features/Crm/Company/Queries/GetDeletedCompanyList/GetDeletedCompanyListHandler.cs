using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Company.Queries.GetDeletedCompanyList
{
    public class GetDeletedCompanyListHandler : IRequestHandler<GetDeletedCompanyListQuery, List<GetDeletedCompanyVm>>
    {
        private readonly IAsyncCompanyRepository _companyRepository;
        private readonly ILogger<GetDeletedCompanyListHandler> _logger;

        public GetDeletedCompanyListHandler(IAsyncCompanyRepository companyRepository, ILogger<GetDeletedCompanyListHandler> logger)
        {
            _companyRepository = companyRepository;
            _logger = logger;
        }

        public async Task<List<GetDeletedCompanyVm>> Handle(GetDeletedCompanyListQuery request, CancellationToken cancellationToken)
        {
            List<GetDeletedCompanyVm> companies = new List<GetDeletedCompanyVm>();
            try
            {
                companies = await _companyRepository.GetDeletedCompanies(request.TenantId, request.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting product list failed due to an error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return companies;
        }
    }
}
