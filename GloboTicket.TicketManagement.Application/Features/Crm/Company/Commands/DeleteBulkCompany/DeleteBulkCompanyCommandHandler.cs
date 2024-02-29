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

namespace ERPCubes.Application.Features.Crm.Company.Commands.DeleteBulkCompany
{
    public class DeleteBulkCompanyCommandHandler : IRequestHandler<DeleteBulkCompanyCommand>
    {
        private readonly IAsyncCompanyRepository _companyRepository;
        private readonly ILogger<DeleteBulkCompanyCommandHandler> _logger;
        public DeleteBulkCompanyCommandHandler(IAsyncCompanyRepository companyRepository, ILogger<DeleteBulkCompanyCommandHandler> logger)
        {
            _companyRepository = companyRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(DeleteBulkCompanyCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _companyRepository.DeleteBulkCompany(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting Bulk companies {request.Companies} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
