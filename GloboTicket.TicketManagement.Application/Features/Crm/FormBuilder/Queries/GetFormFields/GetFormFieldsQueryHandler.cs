using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetFormFields
{
    public class GetFormFieldsQueryHandler: IRequestHandler<GetFormFieldsQuery, List<GetFormFieldsVm>>
    {
        private readonly IAsyncFormsRepository _formsRepository;
        private readonly ILogger<GetFormFieldsQueryHandler> _logger;
        public GetFormFieldsQueryHandler(IAsyncFormsRepository formsRepository, ILogger<GetFormFieldsQueryHandler> logger)
        {
            _formsRepository = formsRepository;
            _logger = logger;
        }
        public async Task<List<GetFormFieldsVm>> Handle(GetFormFieldsQuery request, CancellationToken token)
        {
            List<GetFormFieldsVm> formFields = new List<GetFormFieldsVm>();
            try
            {
                formFields = await _formsRepository.GetFormFields(request.FormId, request.TenantGuid);

            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting FormFields of FormId: {request.FormId} failed due to: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return formFields;
        }
    }
}
