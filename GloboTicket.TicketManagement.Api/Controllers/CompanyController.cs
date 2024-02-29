using ERPCubes.Application.Features.Crm.Company.Commands.BulkAssignCompany;
using ERPCubes.Application.Features.Crm.Company.Commands.DeleteBulkCompany;
using ERPCubes.Application.Features.Crm.Company.Commands.DeleteCompany;
using ERPCubes.Application.Features.Crm.Company.Commands.RestoreBulkCompany;
using ERPCubes.Application.Features.Crm.Company.Commands.RestoreCompany;
using ERPCubes.Application.Features.Crm.Company.Commands.SaveCompany;
using ERPCubes.Application.Features.Crm.Company.Queries.GetCompanyList;
using ERPCubes.Application.Features.Crm.Company.Queries.GetDeletedCompanyList;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CompanyController : ControllerBase
    {
        private readonly IMediator _mediator;
        public CompanyController(IMediator mediator)
        {
            _mediator = mediator;
        }
        [Authorize]
        [HttpPost("all", Name = "GetAllCompanies")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetCompanyVm>>> GetAllCategories(GetCompanyListQuery getCompanyList)
        {
            var dtos = await _mediator.Send(getCompanyList);
            return Ok(dtos);
        }
        [Authorize]
        [HttpPost("save", Name = "SaveCompany")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<List<ActionResult>>> SaveComapny(SaveCompanyCommand saveCompany)
        {
            var dtos = await _mediator.Send(saveCompany);
            return Ok(dtos);
        }
        [Authorize]
        [HttpPost("delete", Name = "DeletCompany")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<List<ActionResult>>> DeleteComapny(DeleteCompanyCommand deleteCompany)
        {
            var dtos = await _mediator.Send(deleteCompany);
            return Ok(dtos);
        }
        [Authorize]
        [HttpPost("del", Name = "GetDeletedCompanies")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetDeletedCompanyVm>>> GetDeletedCategories(GetDeletedCompanyListQuery company)
        {
            var dtos = await _mediator.Send(company);
            return Ok(dtos);
        }
        [Authorize]
        [HttpPost("restore", Name = "RestoreCompany")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> RestoreCompany(RestoreCompanyCommand restoreCompany)
        {
            var dtos = await _mediator.Send(restoreCompany);
            return Ok(dtos);
        }
        [Authorize]
        [HttpPost("restoreBulk", Name = "RestoreBulkCompany")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> RestoreBulkCompany(RestoreBulkCompanyCommand restoreCompany)
        {
            var dtos = await _mediator.Send(restoreCompany);
            return Ok(dtos);
        }
        [Authorize]
        [HttpPost("bulkdelete", Name = "BulkdeleteCompany")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> DeleteBulkCompany(DeleteBulkCompanyCommand companyCommand)
        {
            var dtos = await _mediator.Send(companyCommand);
            return Ok(dtos);
        }
        [Authorize]
        [HttpPost("bulkassigncompanies", Name = "BulkAssignCompany")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> BulkAssignLeads(BulkAssignCompanyCommand companyCommand)
        {
            var dtos = await _mediator.Send(companyCommand);
            return Ok(dtos);
        }
    }
}
