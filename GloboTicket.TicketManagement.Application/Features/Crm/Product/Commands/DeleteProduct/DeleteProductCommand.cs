using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Product.Commands.DeleteProduct
{
    public class DeleteProductCommand : IRequest
    {
        public int ProductId { get; set; }
        public string Id { get; set; } = String.Empty;

        public string DeletedBy { get; set; }
        public DateTime? DeletedDate { get; set; }
    }
}
