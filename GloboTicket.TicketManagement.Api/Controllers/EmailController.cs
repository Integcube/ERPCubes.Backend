using ERPCubes.Application.Features.Crm.Company.Commands.DeleteCompany;
using ERPCubes.Application.Features.Crm.Company.Queries.GetCompanyList;
using ERPCubes.Application.Features.Crm.Email.Commands.DeleteEmail;
using ERPCubes.Application.Features.Crm.Email.Commands.SaveEmail;
using ERPCubes.Application.Features.Crm.Email.Queries.GetEmailList;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmailController : ControllerBase
    {
        private readonly IMediator _mediator;
        public EmailController(IMediator mediator)
        {
            _mediator = mediator;
        }
        //[Authorize]
        [HttpPost("all", Name = "GetAllEmails")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetEmailVm>>> GetAllCategories(GetEmailListQuery getEmail)
        {
            var dtos = await _mediator.Send(getEmail);
            return Ok(dtos);
        }

        //[Authorize]
        [HttpPost("delete", Name = "DeletEmail")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<List<ActionResult>>> DeleteComapny(DeleteEmailCommand deleteEmail)
        {
            var dtos = await _mediator.Send(deleteEmail);
            return Ok(dtos);
        }

        //[Authorize]
        [HttpPost("save", Name = "SaveEmail")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> SaveEmail(SaveEmailCommand emailCommand)
        {
            var dtos = await _mediator.Send(emailCommand);
            return Ok(dtos);
        }
    }
}
