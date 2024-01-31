using ERPCubes.Application.Features.Crm.Product.Commands.BulkRestoreProduct;
using ERPCubes.Application.Features.Crm.Product.Commands.RestoreProduct;
using ERPCubes.Application.Features.Crm.Product.Commands.SaveProductBulk;
using ERPCubes.Application.Features.Crm.Product.Queries.GetDeletedProductList;
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
        Task SaveProductBulk(SaveProductBulkCommand request);
        Task DeleteProduct(DeleteProductCommand productId);
        Task<List<GetDeletedProductVm>> GetDeletedProducts(int TenantId, string Id);
        Task RestoreProduct(RestoreProductCommand productId);
        Task RestoreBulkProduct(RestoreBulkProductCommand productId);
    }
}
