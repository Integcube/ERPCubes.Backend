using ERPCubes.Application.Features.Crm.Call.Commands.DeleteCall;
using ERPCubes.Application.Features.Crm.Call.Commands.SaveCall;
using ERPCubes.Application.Features.Crm.Call.Queries.GetCallList;
using ERPCubes.Application.Features.Crm.Email.Queries.GetEmailList;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CallController : ControllerBase
    {
        private readonly IMediator _mediator;
        public CallController(IMediator mediator)
        {
            _mediator = mediator;
        }
        //[Authorize]
        [HttpPost("all", Name = "GetAllCalls")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetCallVm>>> GetAllCategories(GetCallListQuery getCall)
        {
            var dtos = await _mediator.Send(getCall);
            return Ok(dtos);
        }

        //[Authorize]
        [HttpPost("delete", Name = "DeleteCalls")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<List<ActionResult>>> DeleteCall(DeleteCallCommand deleteCall)
        {
            var dtos = await _mediator.Send(deleteCall);
            return Ok(dtos);
        }

        //[Authorize]
        [HttpPost("save", Name = "SaveCall")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> SaveCall(SaveCallCommand saveCall)
        {
            var dtos = await _mediator.Send(saveCall);
            return Ok(dtos);
        }
    }
}
