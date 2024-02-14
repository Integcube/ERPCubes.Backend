using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.DocumentLibrary.Command.DeleteDocument;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.DocumentLibrary.Command.AddDocument
{
    public class AddDocumentCommandHandler : IRequestHandler<AddDocumentCommand, AddDocumentCommandVm>
    {
        private readonly ILogger<AddDocumentCommandHandler> _logger;
        private readonly IAsyncDocumentLibraryRepository _documentRepository;
        public AddDocumentCommandHandler(ILogger<AddDocumentCommandHandler> logger, IAsyncDocumentLibraryRepository documentRepository)
        {
            _logger = logger;
            _documentRepository = documentRepository;
        }
        public async Task<AddDocumentCommandVm> Handle(AddDocumentCommand request, CancellationToken cancellationToken)
        {
            try
            {
               var dto =  await _documentRepository.AddDocument(request);
                return dto;

            }
            catch (Exception ex)
            {
                _logger.LogError($"Adding new file failed due to: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
