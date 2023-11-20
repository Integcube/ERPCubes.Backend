using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Task.Queries.GetTaskList;
using ERPCubes.Application.Features.Notes.Queries.GetNoteList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Queries.GetTaskTagsList
{
    public class GetTaskTagsListQueryHandler : IRequestHandler<GetTaskTagsListQuery, List<GetTaskTagsListVm>>
    {
        private readonly IAsyncTaskRepository _taskRepository;
        private readonly ILogger<GetTaskTagsListQueryHandler> _logger;
        public GetTaskTagsListQueryHandler(IAsyncTaskRepository taskRepository, ILogger<GetTaskTagsListQueryHandler> logger)
        {
            _taskRepository = taskRepository;
            _logger = logger;
        }
        public async Task<List<GetTaskTagsListVm>> Handle(GetTaskTagsListQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetTaskTagsListVm> TasksTags = new List<GetTaskTagsListVm>();
                TasksTags = await _taskRepository.GetAllTaskTags(request.TenantId, request.Id, request.TaskId);
                return TasksTags;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Task List failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
