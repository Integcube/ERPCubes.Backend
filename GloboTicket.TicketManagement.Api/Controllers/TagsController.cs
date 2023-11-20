using ERPCubes.Application.Features.Tags.Commands.DeleteTags;
using ERPCubes.Application.Features.Tags.Commands.SaveTags;
using ERPCubes.Application.Features.Tags.Queries.GetTagsList;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TagsController : ControllerBase
    {
        private readonly IMediator _mediator;
        public TagsController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpPost("all", Name = "GetAllTags")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetTagsVm>>> GetAllCategories(GetTagsListQuery getTagsList)
        {
            var dtos = await _mediator.Send(getTagsList);
            return Ok(dtos);
        }

        [HttpPost("delete", Name = "DeleteTag")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> DeleteTag(DeleteTagsCommand deleteTags)
        {
            var dtos = await _mediator.Send(deleteTags);
            return Ok(dtos);
        }

        [HttpPost("save", Name = "SaveAllTags")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> SaveTag(SaveTagsCommand saveTags)
        {
            var dtos = await _mediator.Send(saveTags);
            return Ok(dtos);
        }

    }
}
