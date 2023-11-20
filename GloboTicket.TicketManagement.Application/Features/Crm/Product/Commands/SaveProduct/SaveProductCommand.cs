using ERPCubes.Application.Features.Product.Queries.GetProductList;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Product.Commands.SaveProduct
{
    public class SaveProductCommand : IRequest
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
