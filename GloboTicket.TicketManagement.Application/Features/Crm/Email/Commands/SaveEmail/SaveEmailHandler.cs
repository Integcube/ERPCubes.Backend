using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Email.Commands.SaveEmail
{
    public class SaveEmailHandler : IRequestHandler<SaveEmailCommand>
    {
        private readonly IAsyncEmailRepository _emailRepository;
        private readonly ILogger<SaveEmailHandler> _logger;

        public SaveEmailHandler(IAsyncEmailRepository emailRepository, ILogger<SaveEmailHandler> logger)
        {
            _emailRepository = emailRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveEmailCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _emailRepository.SaveEmail(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving lead {request.EmailId} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);

            }
            return Unit.Value;
        }
    }
}
