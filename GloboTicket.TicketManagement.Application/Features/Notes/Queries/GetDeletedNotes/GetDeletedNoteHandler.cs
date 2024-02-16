using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Notes.Queries.GetDeletedNotes
{
    public class GetDeletedNoteHandler : IRequestHandler<GetDeletedNotesQuery, List<GetDeletedNoteVm>>
    {
        private readonly IAsyncNoteRepository _noteRepository;
        private readonly ILogger<GetDeletedNoteHandler> _logger;

        public GetDeletedNoteHandler(IAsyncNoteRepository noteRepository, ILogger<GetDeletedNoteHandler> logger)
        {
            _noteRepository = noteRepository;
            _logger = logger;
        }

        public async Task<List<GetDeletedNoteVm>> Handle(GetDeletedNotesQuery request, CancellationToken cancellationToken)
        {
            List<GetDeletedNoteVm> notes = new List<GetDeletedNoteVm>();
            try
            {
                notes = await _noteRepository.GetDeletedNotes(request.TenantId, request.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting note list failed due to an error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return notes;
        }
    }
}
