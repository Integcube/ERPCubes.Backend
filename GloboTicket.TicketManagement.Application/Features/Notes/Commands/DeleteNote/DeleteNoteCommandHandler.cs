using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ERPCubes.Application.Features.Notes.Commands.DeleteNote
{
    public class DeleteNoteCommandHandler : IRequestHandler<DeleteNoteCommand>
    {
        private readonly IAsyncNoteRepository _noteRepository;
        private readonly ILogger<DeleteNoteCommandHandler> _logger;
        public DeleteNoteCommandHandler(IAsyncNoteRepository noteRepository, ILogger<DeleteNoteCommandHandler> logger)
        {
            _noteRepository = noteRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(DeleteNoteCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _noteRepository.DeletNote(request);
                return Unit.Value;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting Note :{request.NoteId} failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
