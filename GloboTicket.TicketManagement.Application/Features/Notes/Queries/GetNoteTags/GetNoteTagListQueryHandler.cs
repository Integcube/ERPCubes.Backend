

using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ERPCubes.Application.Features.Notes.Queries.GetNoteTags
{
    public class GetNoteTagListQueryHandler : IRequestHandler<GetNoteTagListQuery, List<NoteTagListVm>>
    {
        private readonly IAsyncNoteRepository _noteRepository;
        private readonly ILogger<GetNoteTagListQueryHandler> _logger;
        public GetNoteTagListQueryHandler(IAsyncNoteRepository noteRepository, ILogger<GetNoteTagListQueryHandler> logger)
        {
            _logger = logger;
            _noteRepository = noteRepository;
        }
        public async Task<List<NoteTagListVm>> Handle(GetNoteTagListQuery request, CancellationToken cancellationToken)
        {
            List<NoteTagListVm> NoteTags = new List<NoteTagListVm>();
            try
            {
                NoteTags = await _noteRepository.GetNoteTagList(request.TenantId, request.Id, request.NoteId);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting note tag list failed due to an error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return NoteTags;
        }
    }
}
