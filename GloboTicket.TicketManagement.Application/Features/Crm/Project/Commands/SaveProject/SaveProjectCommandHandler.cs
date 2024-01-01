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

namespace ERPCubes.Application.Features.Crm.Project.Commands.SaveProject
{
    public class SaveProjectCommandHandler: IRequestHandler<SaveProjectCommand>
    {
        private readonly IAsyncProjectRepository _projectRepository;
        private readonly ILogger<SaveProjectCommandHandler> _logger;

        public SaveProjectCommandHandler(IAsyncProjectRepository projectRepository, ILogger<SaveProjectCommandHandler> logger)
        {
            _projectRepository = projectRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveProjectCommand request, CancellationToken cancellationToken)
        {

            try
            {
                await _projectRepository.SaveProject(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving Project {request.Title} has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }

            return Unit.Value;
        }
    }
}
