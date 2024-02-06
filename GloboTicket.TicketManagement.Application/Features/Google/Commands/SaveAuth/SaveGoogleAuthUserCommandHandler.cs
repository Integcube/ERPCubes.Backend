using ERPCubes.Application.Contracts.Persistence.Facebook;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Facebook.Commands.SaveFacebookUser;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Google.Commands.SaveAuth
{
    public class SaveGoogleAuthUserCommandHandler : IRequestHandler<SaveGoogleAuthUserCommand>
    {
        private readonly IAsyncSocialRepository _google;
        private readonly ILogger<SaveGoogleAuthUserCommandHandler> _logger;

        public SaveGoogleAuthUserCommandHandler(IAsyncSocialRepository facebook, ILogger<SaveGoogleAuthUserCommandHandler> logger)
        {
            _google = facebook;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveGoogleAuthUserCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _google.RegisterGoogleUser(request);
                return Unit.Value;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Saving Task :{request.Id} failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
