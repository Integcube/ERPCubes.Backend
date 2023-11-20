using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Company.Commands.SaveCompany
{
    public class SaveCompanyCommandHandler : IRequestHandler<SaveCompanyCommand>
    {
        private readonly IAsyncCompanyRepository _companyRepository;
        private readonly ILogger<SaveCompanyCommandHandler> _logger;

        public SaveCompanyCommandHandler(IAsyncCompanyRepository companyRepository, ILogger<SaveCompanyCommandHandler> logger)
        {
            _companyRepository = companyRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveCompanyCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _companyRepository.SaveCompany(request.Id, request.TenantId, request.company);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting CompanyId :{request.company.Name} failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);

            }
            return Unit.Value;
        }
    }
}
