using ERPCubes.Application.Contracts.Persistence.Social.Webhooks;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Social.Webhooks.Instagram.Commands;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Social.Webhooks.Whatsapp.Commands
{
    public class WhatsappWebhookCommandHandler : IRequestHandler<WhatsappWebhookCommand, WhatsappWebhookVm>
    {
        private readonly IAsyncWebhookRepository _whatsappRepository;
        private readonly ILogger<WhatsappWebhookCommandHandler> _logger;
        public WhatsappWebhookCommandHandler(IAsyncWebhookRepository whatsappRepository, ILogger<WhatsappWebhookCommandHandler> logger)
        {
            _logger = logger;
            _whatsappRepository = whatsappRepository;
        }

        public async Task<WhatsappWebhookVm> Handle(WhatsappWebhookCommand request, CancellationToken cancellationToken)
        {
            try
            {
                WhatsappWebhookVm message = await _whatsappRepository.SaveWhatsappMessage(request);
                return message;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving WhatsApp message caused error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
