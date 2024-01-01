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

namespace ERPCubes.Application.Features.Crm.Project.Queries.GetProjects
{
    public class GetProjectsQueryHandler: IRequestHandler<GetProjectsQuery, List<GetProjectsVm>>
    {
        private readonly IAsyncProjectRepository _projectRepository;
        private readonly ILogger<GetProjectsQueryHandler> _logger;

        public GetProjectsQueryHandler(IMapper mapper, IAsyncProjectRepository projectRepository, ILogger<GetProjectsQueryHandler> logger)
        {
            _projectRepository = projectRepository;
            _logger = logger;
        }
        public async Task<List<GetProjectsVm>> Handle(GetProjectsQuery request, CancellationToken cancellationToken)
        {
            List<GetProjectsVm> projects = new List<GetProjectsVm>();
            try
            {
                projects = await _projectRepository.GetProjects(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting projects list has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }

            return projects;
        }
    }
}
