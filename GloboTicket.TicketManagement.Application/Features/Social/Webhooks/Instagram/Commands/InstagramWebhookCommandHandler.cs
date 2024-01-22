using ERPCubes.Application.Contracts.Persistence.Social.Webhooks;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ERPCubes.Application.Features.Social.Webhooks.Instagram.Commands
{
    public class InstagramWebhookCommandHandler : IRequestHandler<InstagramWebhookCommand, InstagramWebhookVm>
    {
        private readonly IAsyncWebhookRepository _instaRepository;
        private readonly ILogger<InstagramWebhookCommandHandler> _logger;
        public InstagramWebhookCommandHandler(IAsyncWebhookRepository instaRepository, ILogger<InstagramWebhookCommandHandler> logger)
        {
            _logger = logger;
            _instaRepository = instaRepository;
        }
        public async Task<InstagramWebhookVm> Handle(InstagramWebhookCommand request, CancellationToken cancellationToken)
        {
            try
            {
                InstagramWebhookVm message = await _instaRepository.SaveInstaMessage(request);
                return message;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving Instagram message caused error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
