using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.SaveLeadScoreQuestions
{
    public class SaveLeadScoreQuestionsCommandHandler: IRequestHandler<SaveLeadScoreQuestionsCommand>
    {
        private IAsyncLeadRepository _leadRepository;
        private ILogger<SaveLeadScoreQuestionsCommandHandler> _logger;
        public SaveLeadScoreQuestionsCommandHandler(IAsyncLeadRepository leadRepository, ILogger<SaveLeadScoreQuestionsCommandHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveLeadScoreQuestionsCommand request, CancellationToken token)
        {
            try
            {
                await _leadRepository.SaveLeadScoreQuestions(request);
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
