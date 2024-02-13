using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.SaveLeadScoreQuestion
{
    public class SaveLeadScoreQuestionCommandHandler: IRequestHandler<SaveLeadScoreQuestionCommand>
    {
        private IAsyncLeadRepository _leadRepository;
        private ILogger<SaveLeadScoreQuestionCommandHandler> _logger;
        public SaveLeadScoreQuestionCommandHandler(IAsyncLeadRepository leadRepository, ILogger<SaveLeadScoreQuestionCommandHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveLeadScoreQuestionCommand request, CancellationToken token)
        {
            try
            {
                await _leadRepository.SaveLeadScoreQuestion(request);
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
