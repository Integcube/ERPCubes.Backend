using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Product.Commands.SaveProductBulk;
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
                                                              Price = a.Price,
                                                              ProjectId = a.ProjectId,
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
                DateTime localDateTime = DateTime.Now;
                if (product.ProductId == -1)
                {
                    CrmProduct addProduct = new CrmProduct();
                    addProduct.TenantId = product.TenantId;
                    addProduct.ProductName = product.ProductName;
                    addProduct.Price = product.Price;
                    addProduct.Description = product.Description;
                    addProduct.ProjectId = product.ProjectId;
                    addProduct.CreatedBy = product.Id;
                    addProduct.CreatedDate = localDateTime.ToUniversalTime();
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
                        existingProduct.ProjectId = product.ProjectId;
                        existingProduct.LastModifiedBy = product.Id;
                        existingProduct.LastModifiedDate = localDateTime.ToUniversalTime();
                        await _dbContext.SaveChangesAsync();
                    }

                }

            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }

        }

        public async Task SaveProductBulk(SaveProductBulkCommand request)
        {
            try
            {
                DateTime localDateTime = DateTime.Now;
                foreach (var Product in request.Products)
                {
                    CrmProduct ProductObj = new CrmProduct();
                    ProductObj.ProductName = Product.ProductName;
                    ProductObj.Description = Product.Description;
                    ProductObj.Price = Product.Price;
                    ProductObj.ProjectId = Product.ProjectId;
                    ProductObj.CreatedBy = request.Id;
                    ProductObj.CreatedDate = localDateTime.ToUniversalTime();
                    ProductObj.IsDeleted = 0;
                    ProductObj.TenantId = request.TenantId;
                    await _dbContext.AddAsync(ProductObj);
                    await _dbContext.SaveChangesAsync();
                }

            }
            catch (Exception e)
            {
                throw new BadRequestException(e.Message);
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
