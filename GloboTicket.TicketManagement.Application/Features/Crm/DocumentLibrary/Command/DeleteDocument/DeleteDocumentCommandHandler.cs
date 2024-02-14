using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.DocumentLibrary.Command.DeleteDocument
{
    public class DeleteDocumentCommandHandler: IRequestHandler<DeleteDocumentCommand>
    {
        private readonly ILogger<DeleteDocumentCommandHandler> _logger;
        private readonly IAsyncDocumentLibraryRepository _documentRepository;
        public DeleteDocumentCommandHandler(ILogger<DeleteDocumentCommandHandler> logger, IAsyncDocumentLibraryRepository documentRepository)
        {
            _logger = logger;
            _documentRepository = documentRepository;
        }
        public async Task<Unit> Handle(DeleteDocumentCommand request, CancellationToken token)
        {
            try
            {
                await _documentRepository.DeleteDocument(request.FileId, request.Id, request.TenantId);
                return Unit.Value;

            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting FileId {request.FileId} failed due to: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
