using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Company.Commands.DeleteCompany
{
    public class DeleteCompanyCommandHandler : IRequestHandler<DeleteCompanyCommand>
    {
        private readonly IAsyncCompanyRepository _companyRepository;
        private readonly ILogger<DeleteCompanyCommandHandler> _logger;
        public DeleteCompanyCommandHandler(IAsyncCompanyRepository companyRepository, ILogger<DeleteCompanyCommandHandler> logger)
        {
            _companyRepository = companyRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(DeleteCompanyCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _companyRepository.DeleteCompany(request);
            }
            catch (Exception ex)
            {

                _logger.LogError($"Deleting CompanyId :{request.CompanyId} failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
