using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Email.Commands.DeleteEmail;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ERPCubes.Application.Features.Product.Commands.DeleteProduct
{
    public class DeleteProductCommandHandler : IRequestHandler<DeleteProductCommand>
    {
        private readonly IAsyncProductRepository _productRepository;
        private readonly ILogger<DeleteProductCommandHandler> _logger;
        public DeleteProductCommandHandler(IAsyncProductRepository productRepository, ILogger<DeleteProductCommandHandler> logger)
        {
            _productRepository = productRepository;
            _logger = logger;

        }
        public async Task<Unit> Handle(DeleteProductCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _productRepository.DeleteProduct(request);
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
