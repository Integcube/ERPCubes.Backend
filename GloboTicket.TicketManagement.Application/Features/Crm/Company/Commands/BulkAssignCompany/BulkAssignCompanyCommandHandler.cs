using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Company.Commands.BulkAssignCompany
{
    public class BulkAssignCompanyCommandHandler : IRequestHandler<BulkAssignCompanyCommand>
    {
        private readonly IAsyncCompanyRepository _companyRepository;
        private readonly ILogger<BulkAssignCompanyCommandHandler> _logger;
        public BulkAssignCompanyCommandHandler(IAsyncCompanyRepository companyRepository, ILogger<BulkAssignCompanyCommandHandler> logger)
        {
            _companyRepository = companyRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(BulkAssignCompanyCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _companyRepository.BulkAssignCompany(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting bulk companies {request.Companies} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
