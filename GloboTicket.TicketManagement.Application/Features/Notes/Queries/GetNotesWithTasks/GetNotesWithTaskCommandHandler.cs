using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ERPCubes.Application.Features.Notes.Queries.GetNotesWithTasks
{
    public class GetNotesWithTaskCommandHandler : IRequestHandler<GetNotesWithTaskCommand, List<GetNotesWithTasksVm>>
    {
        private readonly IAsyncNoteRepository _noteRepository;
        private readonly ILogger<GetNotesWithTaskCommandHandler> _logger;
        public GetNotesWithTaskCommandHandler(IAsyncNoteRepository noteRepository, ILogger<GetNotesWithTaskCommandHandler> logger)
        {
            _noteRepository = noteRepository;
            _logger = logger;
        }
        public async Task<List<GetNotesWithTasksVm>> Handle(GetNotesWithTaskCommand request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetNotesWithTasksVm> NoteList = await _noteRepository.GetNoteListWithTasks(request.TenantId, request.Id);
                return NoteList;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting note list with tasks failed due to an error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
