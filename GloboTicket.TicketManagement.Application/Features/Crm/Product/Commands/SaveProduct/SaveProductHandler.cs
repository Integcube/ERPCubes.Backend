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

namespace ERPCubes.Application.Features.Product.Commands.SaveProduct
{
    public class SaveProductHandler : IRequestHandler<SaveProductCommand>
    {
        private readonly IAsyncProductRepository _productRepository;
      

        public SaveProductHandler(IAsyncProductRepository productRepository)
        {
            _productRepository = productRepository;
     
        }
        public  async Task<Unit> Handle(SaveProductCommand request, CancellationToken cancellationToken)
        {
            try
            {
               await _productRepository.saveProductCommands(request);
            }
            catch (Exception ex)
            {
                throw new NotImplementedException();
                throw new BadRequestException(ex.Message);

            }
            return Unit.Value;
        }
    }
}
