using ERPCubes.Application.Features.Crm.Task.Queries.GetTaskList;
using ERPCubes.Application.Features.Crm.Task.Queries.GetTaskTagsList;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TaskController : ControllerBase
    {
        private readonly IMediator _mediator;
        public TaskController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpPost("all", Name = "GetAllCrmTasks")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetCrmTaskListVm>>> GetAllCrmTasks(GetCrmTaskListQuery getTaskList)
        {
            var dtos = await _mediator.Send(getTaskList);
            return Ok(dtos);
        }
        [HttpPost("tags", Name = "GetAllTaskTags")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetTaskTagsListVm>>> GetAllTags(GetTaskTagsListQuery getTaskList)
        {
            var dtos = await _mediator.Send(getTaskList);
            return Ok(dtos);
        }
    }
}
