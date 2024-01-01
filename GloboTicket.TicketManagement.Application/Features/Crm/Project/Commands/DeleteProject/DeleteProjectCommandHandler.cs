using AutoMapper;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Project.Commands.DeleteProject
{
    public class DeleteProjectCommandHandler: IRequestHandler<DeleteProjectCommand>
    {
        private readonly IAsyncProjectRepository _projectRepository;
        private readonly ILogger<DeleteProjectCommandHandler> _logger;

        public DeleteProjectCommandHandler(IAsyncProjectRepository projectRepository, ILogger<DeleteProjectCommandHandler> logger)
        {
            _projectRepository = projectRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(DeleteProjectCommand request, CancellationToken cancellationToken)
        {

            try
            {
                await _projectRepository.DeleteProject(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"deleting Project {request.ProjectId} has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }
}
