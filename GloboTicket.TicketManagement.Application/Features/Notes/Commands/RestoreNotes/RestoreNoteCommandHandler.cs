using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Notes.Commands.DeleteNote;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Notes.Commands.RestoreNotes
{
    public class RestoreNoteCommandHandler : IRequestHandler<RestoreNoteCommand>
    {
        private readonly IAsyncNoteRepository _noteRepository;
        private readonly ILogger<RestoreNoteCommandHandler> _logger;
        public RestoreNoteCommandHandler(IAsyncNoteRepository noteRepository, ILogger<RestoreNoteCommandHandler> logger)
        {
            _noteRepository = noteRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(RestoreNoteCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _noteRepository.RestoreNote(request);
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
