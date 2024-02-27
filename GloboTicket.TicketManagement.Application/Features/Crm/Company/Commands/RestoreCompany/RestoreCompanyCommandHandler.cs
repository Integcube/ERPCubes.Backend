using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Company.Commands.DeleteCompany;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Company.Commands.RestoreCompany
{
    public class RestoreCompanyCommandHandler : IRequestHandler<RestoreCompanyCommand>
    {
        private readonly IAsyncCompanyRepository _companyRepository;
        private readonly ILogger<RestoreCompanyCommandHandler> _logger;
        public RestoreCompanyCommandHandler(IAsyncCompanyRepository companyRepository, ILogger<RestoreCompanyCommandHandler> logger)
        {
            _companyRepository = companyRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(RestoreCompanyCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _companyRepository.RestoreCompany(request);
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
