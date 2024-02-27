using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Company.Commands.RestoreCompany;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Company.Commands.RestoreBulkCompany
{
    public class RestoreBulkCompanyCommandHandler : IRequestHandler<RestoreBulkCompanyCommand>
    {
        private readonly IAsyncCompanyRepository _companyRepository;
        private readonly ILogger<RestoreBulkCompanyCommandHandler> _logger;
        public RestoreBulkCompanyCommandHandler(IAsyncCompanyRepository companyRepository, ILogger<RestoreBulkCompanyCommandHandler> logger)
        {
            _companyRepository = companyRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(RestoreBulkCompanyCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _companyRepository.RestoreBulkCompany(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting product {request.CompanyId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
