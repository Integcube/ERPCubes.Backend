using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Product.Queries.GetProductList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList
{
    public class GetDeletedProductListHandler : IRequestHandler<GetDeletedProductListQuery, List<GetDeletedProductVm>>
    {
        private readonly IAsyncProductRepository _productRepository;
        private readonly ILogger<GetDeletedProductListHandler> _logger;

        public GetDeletedProductListHandler(IAsyncProductRepository productRepository, ILogger<GetDeletedProductListHandler> logger)
        {
            _productRepository = productRepository;
            _logger = logger;
        }
        public async Task<List<GetDeletedProductVm>> Handle(GetDeletedProductListQuery request, CancellationToken cancellationToken)
        {
            List<GetDeletedProductVm> products = new List<GetDeletedProductVm>();
            try
            {
                products = await _productRepository.GetDeletedProducts(request.TenantId, request.Id);
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
