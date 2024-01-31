using ERPCubes.Application.Features.AppUser.Commands.DeleteUser;
using ERPCubes.Application.Features.AppUser.Commands.UpdateUser;
using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly IMediator _mediator;
        public UsersController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [HttpPost("all", Name = "GetAllUsers")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetUserListVm>>> GetAllUsers(GetUserListQuery getUserList)
        {
            var dto = await _mediator.Send(getUserList);
            return Ok(dto);
        }
        [HttpPost("update", Name = "UpdateAllUsers")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> UpdateUserList(UpdateUserCommand updateRequest)
        {

            var dtos = await _mediator.Send(updateRequest);
            return Ok(dtos);
        }

        [HttpPost("delete", Name = "DeleteUser")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> DeleteUser(DeleteUserCommand getUserList)
        {
            var dto = await _mediator.Send( getUserList);
            return Ok(dto);
        }
        


    }
}
