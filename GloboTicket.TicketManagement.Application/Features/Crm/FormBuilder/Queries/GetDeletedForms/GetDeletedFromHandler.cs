using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Campaign.Queries.GetDeletedCampaigns;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetFieldTypes;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetDeletedForms
{
    public class GetDeletedFromHandler : IRequestHandler<GetDeletedFormQuery, List<GetDeletedFormVm>>
    {
        private readonly IAsyncFormsRepository _formsRepository;
        private readonly ILogger<GetDeletedFromHandler> _logger;
        public GetDeletedFromHandler(IAsyncFormsRepository formsRepository, ILogger<GetDeletedFromHandler> logger)
        {
            _formsRepository = formsRepository;
            _logger = logger;
        }

        public async Task<List<GetDeletedFormVm>> Handle(GetDeletedFormQuery request, CancellationToken cancellationToken)
        {
            List<GetDeletedFormVm> forms = new List<GetDeletedFormVm>();
            try
            {
                forms = await _formsRepository.GetDeletedForms(request.TenantId, request.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting forms list failed due to an error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return forms;
        }
    }
}
