using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.CustomLists.Queries.GetCustomLists;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.CustomLists.Commands.DeleteCustomList
{
    public class DeleteCustomListCommandHandler : IRequestHandler<DeleteCustomListCommand>
    {
        private readonly IAsyncCustomListRepository _customRepository;
        private readonly ILogger<DeleteCustomListCommandHandler> _logger;
        public DeleteCustomListCommandHandler(IAsyncCustomListRepository customRepository, ILogger<DeleteCustomListCommandHandler> logger)
        {
            _customRepository = customRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(DeleteCustomListCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _customRepository.DeleteCustomList(request);
                return Unit.Value;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Delete Custom List {request.ListTitle}  failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
