using ERPCubes.Application.Features.Company.Commands.DeleteCompany;
using ERPCubes.Application.Features.Company.Queries.GetCompanyList;
using ERPCubes.Application.Features.Lead.Queries.GetLeadList;
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
        [HttpPost("delete", Name = "DeletCompany")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<List<ActionResult>>> DeleteComapny(DeleteCompanyCommand deleteCompany)
        {
            var dtos = await _mediator.Send(deleteCompany);
            return Ok(dtos);
        }
    }
}
