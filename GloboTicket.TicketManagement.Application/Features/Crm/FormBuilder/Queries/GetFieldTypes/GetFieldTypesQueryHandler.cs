using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetFormFields;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetFieldTypes
{
    public class GetFieldTypesQueryHandler: IRequestHandler<GetFieldTypesQuery, List<GetFieldTypesVm>>
    {
        private readonly IAsyncFormsRepository _formsRepository;
        private readonly ILogger<GetFieldTypesQueryHandler> _logger;
        public GetFieldTypesQueryHandler(IAsyncFormsRepository formsRepository, ILogger<GetFieldTypesQueryHandler> logger)
        {
            _formsRepository = formsRepository;
            _logger = logger;
        }
        public async Task<List<GetFieldTypesVm>> Handle(GetFieldTypesQuery request, CancellationToken token)
        {
            List<GetFieldTypesVm> types = new List<GetFieldTypesVm>();
            try
            {
                types = await _formsRepository.GetAllFieldTypes();

            }
            catch(Exception ex)
            {
                _logger.LogError($"Getting All Field Types failed due to: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return types;
        }
    }
}
