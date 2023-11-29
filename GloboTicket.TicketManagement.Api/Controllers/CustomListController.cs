using ERPCubes.Application.Features.Crm.CustomLists.Commands.DeleteCustomList;
using ERPCubes.Application.Features.Crm.CustomLists.Commands.SaveCustomList;
using ERPCubes.Application.Features.Crm.CustomLists.Commands.SaveCustomListFilters;
using ERPCubes.Application.Features.Crm.CustomLists.Queries.GetCustomLists;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadList;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CustomListController : ControllerBase
    {
        private readonly IMediator _mediator;
        public CustomListController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [HttpPost("all", Name = "GetAllLists")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetLeadVm>>> GetAllLists(GetCustomListQuery getLeadList)
        {
            var dtos = await _mediator.Send(getLeadList);
            return Ok(dtos);
        }
        [Authorize]
        [HttpPost("save", Name = "SaveCustomList")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> SaveCustomList(SaveCustomListCommand leadCommand)
        {
            var dtos = await _mediator.Send(leadCommand);
            return Ok(dtos);
        }

        [Authorize]
        [HttpPost("delete", Name = "DeleteCustomList")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> DeleteCustomList(DeleteCustomListCommand leadCommand)
        {
            var dtos = await _mediator.Send(leadCommand);
            return Ok(dtos);
        }
        [Authorize]
        [HttpPost("saveFilter", Name = "SaveCustomListFilter")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> SaveCustomListFilter(SaveCustomListFilterCommand leadCommand)
        {
            var dtos = await _mediator.Send(leadCommand);
            return Ok(dtos);
        }

    }
}
