using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Tags.Commands.SaveTags;
using ERPCubes.Application.Features.Tags.Commands.DeleteTags;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ERPCubes.Application.Features.Tags.Commands.SaveTags
{
    public class SaveTagsHandler : IRequestHandler<SaveTagsCommand, SaveTagVm>
    {
        private readonly IAsyncTagsRepository _tagsRepository;
        private readonly ILogger<SaveTagsHandler> _logger;


        public SaveTagsHandler(IAsyncTagsRepository tagsRepository, ILogger<SaveTagsHandler> logger)
        {
            _tagsRepository = tagsRepository;
            _logger = logger;
        }
        public async Task<SaveTagVm> Handle(SaveTagsCommand request, CancellationToken cancellationToken)
        {
            try
            {
                SaveTagVm tag = await _tagsRepository.SaveTags(request);
                return tag;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving Tag :{request.TagTitle} failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }

        }
    }
}
