using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Product.Commands.RestoreProduct
{
    public class RestoreProductCommand : IRequest
    {
        public int ProductId { get; set; }

    }
}
