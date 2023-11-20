using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tags.Commands.DeleteTags
{
    public class DeleteTagsCommandHandler : IRequestHandler<DeleteTagsCommand>
    {
        private readonly IAsyncTagsRepository _tagsRepository;
        private readonly ILogger<DeleteTagsCommandHandler> _logger;


        public DeleteTagsCommandHandler(IAsyncTagsRepository tagsRepository, ILogger<DeleteTagsCommandHandler> logger)
        {
            _tagsRepository = tagsRepository;
            _logger = logger;
        }
        public async Task<Unit> Handle(DeleteTagsCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _tagsRepository.DeleteTags(request);
            }
            catch(Exception ex)
            {
                _logger.LogError($"Deleting Tag :{request.TagId} failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return Unit.Value;
        }
    }

}
