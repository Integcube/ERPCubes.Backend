using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.SaveCopyQuestion
{
    public class SaveCopyQuestionCommandHandler : IRequestHandler<SaveCopyQuestionCommand>
    {
        private IAsyncLeadRepository _leadRepository;
        private ILogger<SaveCopyQuestionCommandHandler> _logger;
        public SaveCopyQuestionCommandHandler(IAsyncLeadRepository leadRepository, ILogger<SaveCopyQuestionCommandHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveCopyQuestionCommand request, CancellationToken token)
        {
            try
            {
                await _leadRepository.SaveCopyQuestion(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Lead Score Questions could not be saved due to: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
