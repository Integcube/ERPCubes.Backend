using ERPCubes.Application.Features.Crm.Email.Queries.GetEmailList;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveForm;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveFormFields;
using ERPCubes.Application.Features.Crm.FormBuilder.Commands.SaveFormResult;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetFieldTypes;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetFormFields;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetForms;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetFormsList;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FormsController : ControllerBase
    {
        private readonly IMediator _mediator;
        public FormsController(IMediator mediator)
        {
            _mediator = mediator;
        }
        //[Authorize]
        [HttpPost("allTypes", Name = "GetAllFieldTypes")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetFieldTypesVm>>> GetAllFieldTypes(GetFieldTypesQuery getFieldTypes)
        {
            var dtos = await _mediator.Send(getFieldTypes);
            return Ok(dtos);
        }
        //[Authorize]
        [HttpPost("all", Name = "GetAllForms")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetFormsListVm>>> GetAllForms(GetFormsListQuery getForms)
        {
            var dtos = await _mediator.Send(getForms);
            return Ok(dtos);
        }
        //[Authorize]
        [HttpPost("allFields", Name = "GetFormFields")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetFormFieldsVm>>> GetFormFields(GetFormFieldsQuery getFormFields)
        {
            var dtos = await _mediator.Send(getFormFields);
            return Ok(dtos);
        }
        //[Authorize]
        [HttpPost("save", Name = "SaveForm")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> SaveForm(SaveFormCommand saveForm)
        {
            var dtos = await _mediator.Send(saveForm);
            return Ok(dtos);
        }
        //[Authorize]
        [HttpPost("saveFields", Name = "SaveFormFields")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> SaveFormFields(SaveFormFieldsCommand saveFormFields)
        {
            var dtos = await _mediator.Send(saveFormFields);
            return Ok(dtos);
        }
        //[Authorize]
        [HttpPost("saveResult", Name = "SaveFormResult")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult> SaveFormResult(SaveFormResultCommand saveFormResult)
        {
            var dtos = await _mediator.Send(saveFormResult);
            return Ok(dtos);
        }
    }
}
