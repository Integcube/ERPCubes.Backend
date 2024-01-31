using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Product.Commands.BulkRestoreProduct
{
    public class RestoreBulkProductCommand : IRequest
    {
        public List<int> ProductId { get; set; }
    }
}
