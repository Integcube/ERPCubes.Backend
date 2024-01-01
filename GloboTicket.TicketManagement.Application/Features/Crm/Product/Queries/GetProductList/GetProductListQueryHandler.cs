using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;


namespace ERPCubes.Application.Features.Product.Queries.GetProductList
{
    public class GetProductListQueryHandler : IRequestHandler<GetProductListQuery, List<GetProductVm>>
    {
        private readonly IAsyncProductRepository _productRepository;
        private readonly ILogger<GetProductListQueryHandler> _logger;

        public GetProductListQueryHandler(IAsyncProductRepository productRepository, ILogger<GetProductListQueryHandler> logger)
        {
            _productRepository = productRepository;
            _logger = logger;
        }

        public async Task<List<GetProductVm>> Handle(GetProductListQuery request, CancellationToken cancellationToken)
        {
            List<GetProductVm> products = new List<GetProductVm>();
            try
            {
                products = await _productRepository.GetAllProducts(request.TenantId, request.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting product list failed due to an error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return products;
        }
    }
}
