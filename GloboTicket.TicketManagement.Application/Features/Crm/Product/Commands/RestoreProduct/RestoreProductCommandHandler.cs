using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Product.Commands.DeleteProduct;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Product.Commands.RestoreProduct
{
    public class RestoreProductCommandHandler : IRequestHandler<RestoreProductCommand>
    {
        private readonly IAsyncProductRepository _productRepository;
        private readonly ILogger<RestoreProductCommandHandler> _logger;
        public RestoreProductCommandHandler(IAsyncProductRepository productRepository, ILogger<RestoreProductCommandHandler> logger)
        {
            _productRepository = productRepository;
            _logger = logger;

        }
        public async Task<Unit> Handle(RestoreProductCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _productRepository.RestoreProduct(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting product {request.ProductId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
