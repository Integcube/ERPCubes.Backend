using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Tags.Commands.DeleteTags;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ERPCubes.Application.Features.Tags.Commands.SaveTags
{
    public class SaveTagsHandler : IRequestHandler<SaveTagsCommand>
    {
        private readonly IAsyncTagsRepository _tagsRepository;
        private readonly ILogger<SaveTagsHandler> _logger;


        public SaveTagsHandler(IAsyncTagsRepository tagsRepository, ILogger<SaveTagsHandler> logger)
        {
            _tagsRepository = tagsRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveTagsCommand request, CancellationToken cancellationToken)
        {
            try
            {
               await _tagsRepository.SaveTags(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving Tag :{request.TagTitle} failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;

        }
    }
}
