using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Email.Commands.SaveEmail;
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
        private readonly ILogger<SaveProductHandler> _logger;

        public SaveProductHandler(IAsyncProductRepository productRepository, ILogger<SaveProductHandler> logger)
        {
            _productRepository = productRepository;
            _logger = logger;

        }
        public  async Task<Unit> Handle(SaveProductCommand request, CancellationToken cancellationToken)
        {
            try
            {
               await _productRepository.SaveProduct(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving product {request.ProductId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);

            }
            return Unit.Value;
        }
    }
}
