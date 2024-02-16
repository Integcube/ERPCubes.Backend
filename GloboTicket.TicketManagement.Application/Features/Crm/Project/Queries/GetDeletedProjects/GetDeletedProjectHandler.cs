using AutoMapper;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetDeletedForms;
using ERPCubes.Application.Features.Crm.Project.Queries.GetProjects;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Project.Queries.GetDeletedProjects
{
    public class GetDeletedProjectHandler : IRequestHandler<GetDeletedProjectQuery, List<GetDeletedProjectVm>>
    {
        private readonly IAsyncProjectRepository _projectRepository;
        private readonly ILogger<GetDeletedProjectHandler> _logger;

        public GetDeletedProjectHandler(IMapper mapper, IAsyncProjectRepository projectRepository, ILogger<GetDeletedProjectHandler> logger)
        {
            _projectRepository = projectRepository;
            _logger = logger;
        }

        public async Task<List<GetDeletedProjectVm>> Handle(GetDeletedProjectQuery request, CancellationToken cancellationToken)
        {
            List<GetDeletedProjectVm> projects = new List<GetDeletedProjectVm>();
            try
            {
                projects = await _projectRepository.GetDeletedProjects(request.TenantId, request.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting forms list failed due to an error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return projects;
        }
    }
}
