using ERPCubes.Application.Features.AppUser.Commands.BulkRestoreUser;
using ERPCubes.Application.Features.AppUser.Commands.DeleteUser;
using ERPCubes.Application.Features.AppUser.Commands.RestoreUser;
using ERPCubes.Application.Features.AppUser.Commands.UpdateUser;
using ERPCubes.Application.Features.AppUser.Queries.GetDeletedUserList;
using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Application.Features.AppUser.Queries.LazyGetUserList;
using ERPCubes.Application.Features.Crm.Product.Commands.BulkRestoreProduct;
using ERPCubes.Application.Features.Crm.Product.Commands.RestoreProduct;
using ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList;
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
        [HttpPost("lazyall", Name = "LazyGetAllUsers")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<LazyGetUserListVm>> LazyGetAllUsers (LazyGetUserListQuery getUserList)
        {
            var dto = await _mediator.Send(getUserList);
            return Ok(dto);
        }

        [HttpPost("all", Name = "GetAllUsers")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<GetUserListVm>> GetAllUsers(GetUserListQuery getUserList)
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

        [HttpPost("del", Name = "GetDeletedUsers")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetDeletedUserListVm>>> GetDeletedUsers(GetDeletedUserListQuery getUserList)
        {
            var dtos = await _mediator.Send(getUserList);
            return Ok(dtos);
        }

        [HttpPost("restore", Name = "RestoreUser")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> RestoreUser(RestoreUserCommand user)
        {
            var dtos = await _mediator.Send(user);
            return Ok(dtos);
        }

        [HttpPost("restoreBulkUser", Name = "RestoreBulkUser")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> RestoreBulkUser(RestoreBulkUserCommand user)
        {
            var dtos = await _mediator.Send(user);
            return Ok(dtos);
        }
    }
}
