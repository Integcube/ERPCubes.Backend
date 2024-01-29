using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ERPCubes.Application.Features.Crm.Product.Commands.SaveProductBulk
{
    public class SaveProductBulkCommandHandler : IRequestHandler<SaveProductBulkCommand>
    {
        private readonly IAsyncProductRepository _productRepository;
        private readonly ILogger<SaveProductBulkCommandHandler> _logger;
        public SaveProductBulkCommandHandler(IAsyncProductRepository productRepository, ILogger<SaveProductBulkCommandHandler> logger)
        {
            _productRepository = productRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveProductBulkCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _productRepository.SaveProductBulk(request);
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
