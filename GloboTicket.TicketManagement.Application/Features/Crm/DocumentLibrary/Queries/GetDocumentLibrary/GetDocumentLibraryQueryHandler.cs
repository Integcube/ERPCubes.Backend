using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.DocumentLibrary.Queries.GetDocumentLibrary
{
    public class GetDocumentLibraryQueryHandler : IRequestHandler<GetDocumentLibraryQuery, List<GetDocumentLibraryVm>>
    {
        private readonly IAsyncDocumentLibraryRepository _documentlRepository;
        private readonly ILogger<GetDocumentLibraryQueryHandler> _logger;
        public GetDocumentLibraryQueryHandler(IAsyncDocumentLibraryRepository documentlRepository, ILogger<GetDocumentLibraryQueryHandler> logger)
        {
            _documentlRepository = documentlRepository;
            _logger = logger;
        }

        public async Task<List<GetDocumentLibraryVm>> Handle(GetDocumentLibraryQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetDocumentLibraryVm> documents = new List<GetDocumentLibraryVm>();
                documents = await _documentlRepository.GetAllList(request.Id, request.TenantId, request.ParentId, request.ContactTypeId, request.ContactId);
                return documents;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Calls List failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
