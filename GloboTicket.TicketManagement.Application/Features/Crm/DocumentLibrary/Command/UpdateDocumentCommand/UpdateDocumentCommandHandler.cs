using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Company.Commands.DeleteCompany;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.DeleteDocument;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.DocumentLibrary.Command.UpdateDocumentCommand
{
    public class UpdateDocumentCommandHandler: IRequestHandler<UpdateDocumentCommand>
    {
        private readonly ILogger<UpdateDocumentCommandHandler> _logger;
        private readonly IAsyncDocumentLibraryRepository _documentRepository;
        public UpdateDocumentCommandHandler(ILogger<UpdateDocumentCommandHandler> logger, IAsyncDocumentLibraryRepository documentRepository)
        {
            _logger = logger;
            _documentRepository = documentRepository;
        }
        public async Task<Unit> Handle(UpdateDocumentCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _documentRepository.UpdateDocument(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Updating FileId {request.FileId} failed due to: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
