using ERPCubes.Application.Features.Crm.Company.Commands.DeleteCompany;
using ERPCubes.Application.Features.Crm.Company.Commands.RestoreBulkCompany;
using ERPCubes.Application.Features.Crm.Company.Commands.RestoreCompany;
using ERPCubes.Application.Features.Crm.Company.Commands.SaveCompany;
using ERPCubes.Application.Features.Crm.Company.Queries.GetCompanyList;
using ERPCubes.Application.Features.Crm.Company.Queries.GetDeletedCompanyList;
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
        [HttpPost("del", Name = "GetDeletedCompanies")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetDeletedCompanyVm>>> GetDeletedCategories(GetDeletedCompanyListQuery company)
        {
            var dtos = await _mediator.Send(company);
            return Ok(dtos);
        }

        [HttpPost("restore", Name = "RestoreCompany")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> RestoreCompany(RestoreCompanyCommand restoreCompany)
        {
            var dtos = await _mediator.Send(restoreCompany);
            return Ok(dtos);
        }

        [HttpPost("restoreBulk", Name = "RestoreBulkCompany")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> RestoreBulkCompany(RestoreBulkCompanyCommand restoreCompany)
        {
            var dtos = await _mediator.Send(restoreCompany);
            return Ok(dtos);
        }
    }
}
