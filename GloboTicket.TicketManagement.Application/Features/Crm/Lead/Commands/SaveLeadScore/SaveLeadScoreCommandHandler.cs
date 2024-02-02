using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Lead.Commands.DeleteLead;
using ERPCubes.Application.Features.Crm.Lead.Commands.SaveLeadScore;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead
{
    public class SaveLeadScoreCommandHandler : IRequestHandler<SaveLeadScoreCommand>
    {
        private readonly IAsyncLeadRepository _leadRepository;
        private readonly ILogger<SaveLeadScoreCommandHandler> _logger;
        public SaveLeadScoreCommandHandler(IAsyncLeadRepository leadRepository, ILogger<SaveLeadScoreCommandHandler> logger)
        {
            _leadRepository = leadRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveLeadScoreCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _leadRepository.SaveleadScore(request);
            }
            catch (Exception ex)
            {
              
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
