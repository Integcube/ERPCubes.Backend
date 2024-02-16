using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Notes.Commands.RestoreNotes;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Notes.Commands.RestoreBulkNote
{
    public class RestoreBulkNoteCommandHandler : IRequestHandler<RestoreBulkNoteCommand>
    {
        private readonly IAsyncNoteRepository _noteRepository;
        private readonly ILogger<RestoreBulkNoteCommandHandler> _logger;
        public RestoreBulkNoteCommandHandler(IAsyncNoteRepository noteRepository, ILogger<RestoreBulkNoteCommandHandler> logger)
        {
            _noteRepository = noteRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(RestoreBulkNoteCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _noteRepository.RestoreBulkNote(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting note {request.NoteId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
