using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Notes.Queries.GetNoteTags;
using ERPCubes.Application.Features.Notes.Queries.GetNoteTask;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ERPCubes.Application.Features.Notes.Queries.GetNoteTasks
{

    public class GetNoteTaskListQueryHandler : IRequestHandler<GetTaskListQuery, List<NoteTaskListVm>>
    {
        private readonly IAsyncNoteRepository _noteRepository;
        private readonly ILogger<GetNoteTaskListQueryHandler> _logger;
        public GetNoteTaskListQueryHandler(IAsyncNoteRepository noteRepository, ILogger<GetNoteTaskListQueryHandler> logger)
        {
            _logger = logger;
            _noteRepository = noteRepository;
        }
        public async Task<List<NoteTaskListVm>> Handle(GetTaskListQuery request, CancellationToken cancellationToken)
        {
            List<NoteTaskListVm> NoteTask = new List<NoteTaskListVm>();
            try
            {
                NoteTask = await _noteRepository.GetNoteTaskList(request.TenantId, request.Id, request.NoteId);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting note tag list failed due to an error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return NoteTask;
        }

    }
}
