using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Tags.Commands.DeleteTags;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tags.Queries.GetTagsList
{
    public class GetTagsListQueryHandler : IRequestHandler<GetTagsListQuery, List<GetTagsVm>>
    {
        private readonly IAsyncTagsRepository _tagsRepository;
        private readonly ILogger<GetTagsListQueryHandler> _logger;

        public GetTagsListQueryHandler(IAsyncTagsRepository tagsRepository, ILogger<GetTagsListQueryHandler> logger)
        {
            _tagsRepository = tagsRepository;  
            _logger = logger;
        }
        public async Task<List<GetTagsVm>> Handle(GetTagsListQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetTagsVm> tags = new List<GetTagsVm>();
                tags = await _tagsRepository.GetAllTags(request.TenantId);
                return tags;

            }
            catch (Exception ex)
            {
                _logger.LogError($"Geting Tag List failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
