using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Product.Commands.DeleteProduct;
using ERPCubes.Application.Features.Product.Commands.SaveProduct;
using ERPCubes.Application.Features.Product.Queries.GetProductList;
using ERPCubes.Domain.Entities;
using ERPCubes.Identity;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System.Xml.Linq;

namespace ERPCubes.Persistence.Repositories.CRM
{
    public class ProductRepository : BaseRepository<CrmProduct>, IAsyncProductRepository
    {
        public ProductRepository(ERPCubesDbContext dbContext, ERPCubesIdentityDbContext dbContextIdentity) : base(dbContext, dbContextIdentity) { }
        public async Task<List<GetProductVm>> GetAllProducts(int TenantId, string Id)
        {
            try
            {
                List<GetProductVm> productDetail = await (from a in _dbContext.CrmProduct.Where(a => a.TenantId == TenantId && a.IsDeleted == 0)
                                                          select new GetProductVm
                                                          {
                                                              ProductId = a.ProductId,
                                                              ProductName = a.ProductName,
                                                              Description = a.Description,
                                                              Price = a.Price
                                                          }).OrderBy(a => a.ProductName).ToListAsync();
                return productDetail;
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }

        public async Task SaveProduct(SaveProductCommand product)
        {
            try
            {
                if (product.ProductId == -1)
                {
                    CrmProduct addProduct = new CrmProduct();
                    addProduct.TenantId = product.TenantId;
                    addProduct.ProductName = product.ProductName;
                    addProduct.Price = product.Price;
                    addProduct.Description = product.Description;
                    addProduct.CreatedBy = product.Id;
                    await _dbContext.AddAsync(addProduct);
                    await _dbContext.SaveChangesAsync();
                }
                else
                {
                    var existingProduct = await (from a in _dbContext.CrmProduct.Where(a => a.ProductId == product.ProductId)
                                                    select a).FirstAsync();
                    if (existingProduct == null)
                    {
                        throw new NotFoundException(product.ProductName, product.ProductId);
                    }
                    else
                    {
                        existingProduct.ProductName = product.ProductName;
                        existingProduct.Price = product.Price;
                        existingProduct.Description = product.Description;
                        await _dbContext.SaveChangesAsync();
                    }

                }

            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }

        }
        public async Task DeleteProduct(DeleteProductCommand productId)
        {
            try
            {
                var deleteProduct = await (from a in _dbContext.CrmProduct.Where(a => a.ProductId == productId.ProductId)
                                           select a).FirstOrDefaultAsync();
                if (deleteProduct == null)
                {
                    throw new NotFoundException("productId", productId);
                }
                else
                {
                    deleteProduct.IsDeleted = 1;
                    await _dbContext.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
