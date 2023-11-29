using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Call.Commands.DeleteCall
{
    public class DeleteCallCommandHandler : IRequestHandler<DeleteCallCommand>
    {
        private readonly IAsyncCallRepository _calllRepository;
        private readonly ILogger<DeleteCallCommandHandler> _logger;
        public DeleteCallCommandHandler(IAsyncCallRepository callRepository, ILogger<DeleteCallCommandHandler> logger)
        {
            _calllRepository = callRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(DeleteCallCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _calllRepository.DeleteCall(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting call {request.CallId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
