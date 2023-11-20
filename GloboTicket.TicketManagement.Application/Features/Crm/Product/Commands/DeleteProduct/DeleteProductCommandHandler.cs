using ERPCubes.Application.Contracts.Persistence.CRM;
using MediatR;

namespace ERPCubes.Application.Features.Product.Commands.DeleteProduct
{
    public class DeleteProductCommandHandler : IRequestHandler<DeleteProductCommand>
    {
        private readonly IAsyncProductRepository _productRepository;

        public DeleteProductCommandHandler(IAsyncProductRepository productRepository)
        {
            _productRepository = productRepository;

        }
        public async Task<Unit> Handle(DeleteProductCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _productRepository.DeleteProduct(request);
            }
            catch (Exception ex)
            {
                throw new NotImplementedException();
            }
            return Unit.Value;
        }
    }
}
