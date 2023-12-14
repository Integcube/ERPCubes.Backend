using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Task.Commands.SaveTask;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Notes.Commands.SaveNote
{
    public class SaveNoteCommandHandler : IRequestHandler<SaveNoteCommand>
    {
        private readonly IAsyncNoteRepository _noteRepository;
        private readonly ILogger<SaveNoteCommandHandler> _logger;
        public SaveNoteCommandHandler(IAsyncNoteRepository noteRepository, ILogger<SaveNoteCommandHandler> logger)
        {
            _noteRepository = noteRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveNoteCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _noteRepository.SaveNote(request);
                return Unit.Value;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving Task :{request.Note.NoteTitle} failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
