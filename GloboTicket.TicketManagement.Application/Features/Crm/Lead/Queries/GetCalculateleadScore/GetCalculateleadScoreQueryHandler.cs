using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetCalculateleadScore;
using ERPCubes.Application.Features.Crm.Lead.Queries.GetScoreListQuery;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetScoreListQuery
{
    public class GetCalculateleadScoreQueryHandler : IRequestHandler<GetCalculateleadScoreQuery, GetCalculateleadScoreListVm>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<GetCalculateleadScoreQueryHandler> _logger;
        public GetCalculateleadScoreQueryHandler(IAsyncLeadRepository leadRepository, ILogger<GetCalculateleadScoreQueryHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<GetCalculateleadScoreListVm> Handle(GetCalculateleadScoreQuery request, CancellationToken cancellationToken)
        {
           GetCalculateleadScoreListVm statusList = new GetCalculateleadScoreListVm();
            try
            {
                statusList = await _leadRepository.GetCalculateleadScore(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Lead Status list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return statusList;
        }
    }
}
