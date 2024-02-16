using ERPCubes.Application.Features.Crm.Product.Commands.BulkRestoreProduct;
using ERPCubes.Application.Features.Crm.Product.Commands.RestoreProduct;
using ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList;
using ERPCubes.Application.Features.Notes.Commands.DeleteNote;
using ERPCubes.Application.Features.Notes.Commands.RestoreBulkNote;
using ERPCubes.Application.Features.Notes.Commands.RestoreNotes;
using ERPCubes.Application.Features.Notes.Commands.SaveNote;
using ERPCubes.Application.Features.Notes.Queries.GetDeletedNotes;
using ERPCubes.Application.Features.Notes.Queries.GetNoteList;
using ERPCubes.Application.Features.Notes.Queries.GetNotesWithTasks;
using ERPCubes.Application.Features.Notes.Queries.GetNoteTags;
using ERPCubes.Application.Features.Notes.Queries.GetNoteTasks;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotesController : ControllerBase
    {
        private readonly IMediator _mediator;
        public NotesController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [HttpPost("all", Name = "GetAllNotes")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetNoteListVm>>> GetAllNotes(GetNoteListQuery getLeadList)
        {
            var dtos = await _mediator.Send(getLeadList);
            return Ok(dtos);
        }
        [HttpPost("NoteTask", Name = "GetAllNotesWithTasks")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetNoteListVm>>> GetAllNotesWithTasks(GetNotesWithTaskCommand getNoteTask)
        {
            var dtos = await _mediator.Send(getNoteTask);
            return Ok(dtos);
        }
        [HttpPost("tasks", Name = "GetSelectedTasks")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetNoteListVm>>> GetSelectedTasks(GetTaskListQuery getNoteTask)
        {

            var dtos = await _mediator.Send(getNoteTask);
            return Ok(dtos);
        }
        [HttpPost("tags", Name = "GetSelectedTags")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetNoteListVm>>> GetSelectedTags(GetNoteTagListQuery getNoteTags)
        {

            var dtos = await _mediator.Send(getNoteTags);
            return Ok(dtos);
        }
        [HttpPost("save", Name = "SaveNote")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task SaveNote(SaveNoteCommand saveNote)
        {
            var dtos = await _mediator.Send(saveNote);
        }
        [HttpPost("delete", Name = "DeleteNote")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task DeleteNote(DeleteNoteCommand deleteNote)
        {
            var dtos = await _mediator.Send(deleteNote);
        }
        [HttpPost("del", Name = "GetDeletedNotes")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetDeletedNoteVm>>> GetDeletedCategories(GetDeletedNotesQuery notes)
        {
            var dtos = await _mediator.Send(notes);
            return Ok(dtos);
        }
        [HttpPost("restore", Name = "RestoreNote")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> RestoreNote(RestoreNoteCommand note)
        {
            var dtos = await _mediator.Send(note);
            return Ok(dtos);
        }
        [HttpPost("restoreBulk", Name = "RestoreBulkNotes")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> RestoreBulkNote(RestoreBulkNoteCommand note)
        {
            var dtos = await _mediator.Send(note);
            return Ok(dtos);
        }
    }
}
