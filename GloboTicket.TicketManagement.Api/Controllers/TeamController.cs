using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Application.Features.Crm.Team.Commands.DeleteTeam;
using ERPCubes.Application.Features.Crm.Team.Commands.SaveTeam;
using ERPCubes.Application.Features.Crm.Team.Queries.GetTeams;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TeamController : ControllerBase
    {
        private readonly IMediator _mediator;
        public TeamController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpPost("Get")]
        public async Task<ActionResult<List<GetTeamsVm>>> GetTeamListAsync(GetTeamsQuery request)
        {
            var dtos = await _mediator.Send(request);
            return Ok(dtos);
        }


        [HttpPost("Save")]
        public async Task<ActionResult<Unit>> SaveTeamAsync(SaveTeamCommand request)
        {
            var dtos = await _mediator.Send(request);
            return Unit.Value;
        }

        [HttpPost("Delete")]
        public async Task<ActionResult<Unit>> DeleteTeamAsync(DeleteTeamCommand request)
        {
            var dtos = await _mediator.Send(request);
            return Unit.Value;
        }

        [HttpPost("GetUser")]
        public async Task<ActionResult<List<GetUserListVm>>> GetUserListAsync(GetUserListQuery request)
        {
            var dtos = await _mediator.Send(request);
            return Ok(dtos);
        }
        }
    }
