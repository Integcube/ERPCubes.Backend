using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Email.Commands.DeleteEmail
{
    public class DeleteEmailCommandHandler : IRequestHandler<DeleteEmailCommand>
    {
        private readonly IAsyncEmailRepository _emailRepository;
        private readonly ILogger<DeleteEmailCommandHandler> _logger;
        public DeleteEmailCommandHandler(IAsyncEmailRepository emailRepository, ILogger<DeleteEmailCommandHandler> logger)
        {
            _emailRepository = emailRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(DeleteEmailCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _emailRepository.DeleteEmail(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting email {request.EmailId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
