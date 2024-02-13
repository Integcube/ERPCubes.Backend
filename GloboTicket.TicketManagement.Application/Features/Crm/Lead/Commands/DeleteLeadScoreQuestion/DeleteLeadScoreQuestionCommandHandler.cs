using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.DeleteLeadScoreQuestion
{
    public class DeleteLeadScoreQuestionCommandHandler: IRequestHandler<DeleteLeadScoreQuestionCommand>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<DeleteLeadScoreQuestionCommandHandler> _logger;
        public DeleteLeadScoreQuestionCommandHandler(IAsyncLeadRepository leadRepository, ILogger<DeleteLeadScoreQuestionCommandHandler> logger)
        {
            _logger = logger;
            _leadRepository = leadRepository;
        }
        public async Task<Unit> Handle(DeleteLeadScoreQuestionCommand request, CancellationToken token)
        {
            try
            {
                await _leadRepository.DeleteLeadScoreQuestion(request.TenantId, request.QuestionId);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Deleting Lead Score Question {request.QuestionId} was not successful due to: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
