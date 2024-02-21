using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Setting.Commands.Save;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Setting.Commands.Save
{
    public class SaveChatbotHandler : IRequestHandler<SaveChatbotCommand>
    {
        private readonly IAsyncCrmSettingRepository _productRepository;
        private readonly ILogger<SaveChatbotHandler> _logger;

        public SaveChatbotHandler(IAsyncCrmSettingRepository productRepository, ILogger<SaveChatbotHandler> logger)
        {
            _productRepository = productRepository;
            _logger = logger;

        }
        public  async Task<Unit> Handle(SaveChatbotCommand request, CancellationToken cancellationToken)
        {
            try
            {
               await _productRepository.SaveChatbotSetting(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving Chatbot setting {request.Id} failed due to : {ex.Message}");
                throw new BadRequestException(ex.Message);

            }
            return Unit.Value;
        }
    }
}
