using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Project.Commands.DeleteProject;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Project.Commands.RestoreProject
{
    public class RestoreProjectCommandHandler : IRequestHandler<RestoreProjectCommand>
    {
        private readonly IAsyncProjectRepository _projectRepository;
        private readonly ILogger<RestoreProjectCommandHandler> _logger;

        public RestoreProjectCommandHandler(IAsyncProjectRepository projectRepository, ILogger<RestoreProjectCommandHandler> logger)
        {
            _projectRepository = projectRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(RestoreProjectCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _projectRepository.RestoreProject(request);
            }
            catch (Exception ex)
            {
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
