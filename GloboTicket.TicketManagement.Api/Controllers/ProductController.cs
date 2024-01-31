using ERPCubes.Application.Features.Crm.Product.Commands.BulkRestoreProduct;
using ERPCubes.Application.Features.Crm.Product.Commands.RestoreProduct;
using ERPCubes.Application.Features.Crm.Product.Commands.SaveProductBulk;
using ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList;
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
        [HttpPost("bulkSave", Name = "BulkSaveProduct")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> BulkSave(SaveProductBulkCommand productCommand)
        {
            var dtos = await _mediator.Send(productCommand);
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

        [HttpPost("del", Name = "GetDeletedProducts")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<List<GetDeletedProductVm>>> GetDeletedCategories(GetDeletedProductListQuery getProductList)
        {
            var dtos = await _mediator.Send(getProductList);
            return Ok(dtos);
        }

        [HttpPost("restore", Name = "RestoreProduct")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> RestoreProduct(RestoreProductCommand deleteProduct)
        {
            var dtos = await _mediator.Send(deleteProduct);
            return Ok(dtos);
        }

        [HttpPost("restoreBulk", Name = "RestoreBulk")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> RestoreBulkProduct(RestoreBulkProductCommand deleteProduct)
        {
            var dtos = await _mediator.Send(deleteProduct);
            return Ok(dtos);
        }

    }
}
