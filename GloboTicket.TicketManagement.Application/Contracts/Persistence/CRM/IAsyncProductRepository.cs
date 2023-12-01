using ERPCubes.Application.Features.Product.Commands.DeleteProduct;
using ERPCubes.Application.Features.Product.Commands.SaveProduct;
using ERPCubes.Application.Features.Product.Queries.GetProductList;
using ERPCubes.Domain.Entities;
using MediatR;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncProductRepository : IAsyncRepository<CrmProduct>
    {
        Task<List<GetProductVm>> GetAllProducts(int TenantId, string Id);
        Task SaveProduct(SaveProductCommand product);
        Task DeleteProduct(DeleteProductCommand productId);

    }
}
