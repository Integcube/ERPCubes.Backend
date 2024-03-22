using ERPCubes.Application.Features.AppUser.Commands.BulkRestoreUser;
using ERPCubes.Application.Features.AppUser.Commands.DeleteUser;
using ERPCubes.Application.Features.AppUser.Commands.RestoreUser;
using ERPCubes.Application.Features.AppUser.Commands.UpdateUser;
using ERPCubes.Application.Features.AppUser.Queries.GetDeletedUserList;
using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Application.Features.AppUser.Queries.LazyGetUserList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckPoint;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.LazyGetAssignCheckList;
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
    public class CkCheckListController : ControllerBase
    {
        private readonly IMediator _mediator;
        public CkCheckListController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpPost("lazyall", Name = "LazyGetAssignCheckList")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<LazyGetAssignCheckListVm>> GetAll (LazyGetAssignCheckListQuery req)
        {
            var dto = await _mediator.Send(req);
            return Ok(dto);
        }

        [HttpPost("getchecklist", Name = "GetCheckList")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<LazyGetAssignCheckListVm>> GetCheckList(GetCheckListQuery req)
        {
            var dto = await _mediator.Send(req);
            return Ok(dto);
        }

        [HttpPost("getcheckpoint", Name = "GetCheckPoint")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<GetCheckPointVm>> GetCheckPoint(GetCheckPointQuery req)
        {
            var dto = await _mediator.Send(req);
            return Ok(dto);
        }
    }
}
