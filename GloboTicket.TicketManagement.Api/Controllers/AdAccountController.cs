using ERPCubes.Application.Features.Crm.AdAccount.SaveAdAccount;
using ERPCubes.Application.Features.Crm.Call.Commands.SaveCall;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AdAccountController : ControllerBase
    {
        private readonly IMediator _mediator;
        public AdAccountController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [HttpPost("save", Name = "SaveAccount")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> SaveCall(SaveAdAccountCommand saveAccount)
        {
            var dtos = await _mediator.Send(saveAccount);
            return Ok(dtos);
        }
    }
}
