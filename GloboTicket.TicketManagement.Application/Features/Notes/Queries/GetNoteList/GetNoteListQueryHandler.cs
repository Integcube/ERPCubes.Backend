using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Notes.Queries.GetNoteList
{
    public class GetNoteListQueryHandler : IRequestHandler<GetNoteListQuery, List<GetNoteListVm>>
    {
        private readonly IAsyncNoteRepository _noteRepository;
        private readonly ILogger<GetNoteListQueryHandler> _logger;
        public GetNoteListQueryHandler(IAsyncNoteRepository noteRepository, ILogger<GetNoteListQueryHandler> logger)
        {
            _noteRepository = noteRepository;
            _logger = logger;
        }
        public async Task<List<GetNoteListVm>> Handle(GetNoteListQuery request, CancellationToken cancellationToken)
        {
            List<GetNoteListVm> NoteList = new List<GetNoteListVm>();
            try
            {
                NoteList = await _noteRepository.GetNoteList(request.TenantId, request.Id, request.LeadId, request.CompanyId, request.OpportunityId);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting note list failed due to an error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return NoteList;
        }
    }
}
