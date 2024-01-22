using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetForms;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetFormsList
{
    public class GetFormsListQueryHandler: IRequestHandler<GetFormsListQuery, List<GetFormsListVm>>
    {
        private readonly IAsyncFormsRepository _formsRepository;
        private readonly ILogger<GetFormsListQueryHandler> _logger;
        public GetFormsListQueryHandler (IAsyncFormsRepository formsRepository, ILogger<GetFormsListQueryHandler> logger)
        {
            _formsRepository = formsRepository;
            _logger = logger;
        }
        public async Task<List<GetFormsListVm>> Handle(GetFormsListQuery request, CancellationToken token)
        {
            List<GetFormsListVm> forms = new List<GetFormsListVm>();
            try
            {
                forms = await _formsRepository.GetAllForms(request.TenantId);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting All Forms has failed due to: {ex.Message}");
                throw new BadRequestException(ex.Message);

            }
            return forms;
        }
    }
}
