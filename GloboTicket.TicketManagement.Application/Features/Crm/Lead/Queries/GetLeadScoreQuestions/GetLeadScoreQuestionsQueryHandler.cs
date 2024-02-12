using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadScoreQuestions
{
    public class GetLeadScoreQuestionsQueryHandler: IRequestHandler<GetLeadScoreQuestionsQuery, List<GetLeadScoreQuestionsVm>>
    {
        private IAsyncLeadRepository _leadRepository;
        private ILogger<GetLeadScoreQuestionsQueryHandler> _logger;
        public GetLeadScoreQuestionsQueryHandler(IAsyncLeadRepository leadRepository, ILogger<GetLeadScoreQuestionsQueryHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<List<GetLeadScoreQuestionsVm>> Handle( GetLeadScoreQuestionsQuery request, CancellationToken token)
        {
            try
            {
                List<GetLeadScoreQuestionsVm> questions = new List<GetLeadScoreQuestionsVm > ();
                questions = await _leadRepository.GetLeadScoreQuestions(request.TenantId, request.ProductId);
                return questions;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting All Lead Score Questions Failed due to: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }            
        }
    }
}
