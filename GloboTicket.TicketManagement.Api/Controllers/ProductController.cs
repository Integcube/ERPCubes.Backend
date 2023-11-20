using ERPCubes.Application.Features.Product.Commands.DeleteProduct;
using ERPCubes.Application.Features.Product.Commands.SaveProduct;
using ERPCubes.Application.Features.Product.Queries.GetProductList;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ERPCubesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private readonly IMediator _mediator;
        public ProductController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [Authorize]
        [HttpPost("all", Name = "GetAllProducts")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetProductVm>>> GetAllCategories(GetProductListQuery getProductList)
        {
            var dtos = await _mediator.Send(getProductList);
            return Ok(dtos);
        }

        [Authorize]
        [HttpPost("save", Name = "SaveAllProducts")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> SaveProductList(SaveProductCommand saveProduct)
        {
            var dtos = await _mediator.Send(saveProduct);
            return Ok(dtos);
        }
        [Authorize]
        [HttpPost("delete", Name = "DeletProduct")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> DeleteProduct(DeleteProductCommand deleteProduct)
        {
            var dtos = await _mediator.Send(deleteProduct);
            return Ok(dtos);
        }
    }
}
