using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.CustomLists.Commands.DeleteCustomList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.CustomLists.Commands.SaveCustomList
{
    public class SaveCustomListCommandHandler : IRequestHandler<SaveCustomListCommand>
    {
        private readonly IAsyncCustomListRepository _customRepository;
        private readonly ILogger<SaveCustomListCommandHandler> _logger;
        public SaveCustomListCommandHandler(IAsyncCustomListRepository customRepository, ILogger<SaveCustomListCommandHandler> logger)
        {
            _customRepository = customRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveCustomListCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _customRepository.SaveCustomList(request);
                return Unit.Value;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Custom {request.Type} List failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
