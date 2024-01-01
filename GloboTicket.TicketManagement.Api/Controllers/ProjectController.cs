using ERPCubes.Application.Features.Crm.Project.Commands.DeleteProject;
using ERPCubes.Application.Features.Crm.Project.Commands.SaveProject;
using ERPCubes.Application.Features.Crm.Project.Queries.GetProjects;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProjectController : ControllerBase
    {
        private readonly IMediator _mediator;
        public ProjectController(IMediator mediator)
        {
            _mediator = mediator;
        }

        //[Authorize]
        [HttpPost("all", Name = "GetProjects")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetProjectsVm>>> GetProjects(GetProjectsQuery getProjects)
        {
            var dtos = await _mediator.Send(getProjects);
            return Ok(dtos);
        }

        //[Authorize]
        [HttpPost("save", Name = "SaveProject")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> SaveProject(SaveProjectCommand saveProject)
        {
            var dtos = await _mediator.Send(saveProject);
            return Ok(dtos);
        }
        //[Authorize]
        [HttpPost("delete", Name = "DeleteProject")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> DeleteProject(DeleteProjectCommand deleteProject)
        {
            var dtos = await _mediator.Send(deleteProject);
            return Ok(dtos);
        }
    }
}
