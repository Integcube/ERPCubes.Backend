using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ERPCubes.Application.Features.Crm.DocumentLibrary.Command.AddLeadFile
{
    public class AddLeadFileCommandHandler : IRequestHandler<AddLeadFileCommand>
    {
        private readonly ILogger<AddLeadFileCommandHandler> _logger;
        private readonly IAsyncDocumentLibraryRepository _documentRepository;
        public AddLeadFileCommandHandler(ILogger<AddLeadFileCommandHandler> logger, IAsyncDocumentLibraryRepository documentRepository)
        {
            _logger = logger;
            _documentRepository = documentRepository;
        }
        public async Task<Unit> Handle(AddLeadFileCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _documentRepository.AddLeadFile(request);
                return Unit.Value;

            }
            catch (Exception ex)
            {
                _logger.LogError($"Adding new lead file failed due to: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
