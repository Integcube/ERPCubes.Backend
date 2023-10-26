using ERPCubes.Application.Features.Company.GetCompanyList.Queries;
using ERPCubes.Application.Features.Lead.Queries.GetLeadList;
using MediatR;
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
        [HttpPost("all", Name = "GetAllCompanies")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetCompanyVm>>> GetAllCategories(GetCompanyListQuery getCompanyList)
        {
            var dtos = await _mediator.Send(getCompanyList);
            return Ok(dtos);
        }
    }
}
