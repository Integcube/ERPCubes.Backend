using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Product.Commands.RestoreProduct;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Product.Commands.BulkRestoreProduct
{
    public class RestoreBulkProductCommandHandler : IRequestHandler<RestoreBulkProductCommand>
    {
        private readonly IAsyncProductRepository _productRepository;
        private readonly ILogger<RestoreBulkProductCommandHandler> _logger;
        public RestoreBulkProductCommandHandler(IAsyncProductRepository productRepository, ILogger<RestoreBulkProductCommandHandler> logger)
        {
            _productRepository = productRepository;
            _logger = logger;

        }
        public async Task<Unit> Handle(RestoreBulkProductCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _productRepository.RestoreBulkProduct(request);
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
