using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Project.Commands.RestoreProject;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Project.Commands.RestoreBulkProject
{
    public class RestoreBulkProjectCommandHandler : IRequestHandler<RestoreBulkProjectCommand>
    {
        private readonly IAsyncProjectRepository _projectRepository;
        private readonly ILogger<RestoreBulkProjectCommandHandler> _logger;

        public RestoreBulkProjectCommandHandler(IAsyncProjectRepository projectRepository, ILogger<RestoreBulkProjectCommandHandler> logger)
        {
            _projectRepository = projectRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(RestoreBulkProjectCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _projectRepository.RestoreBulkProject(request);
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
