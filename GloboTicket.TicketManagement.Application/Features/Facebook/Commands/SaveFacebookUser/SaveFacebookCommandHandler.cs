using AutoMapper;
using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Contracts.Persistence.Facebook;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Notes.Commands.SaveNote;
using ERPCubes.Domain.Entities;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Facebook.Commands.SaveFacebookUser
{
    public class SaveFacebookCommandHandler : IRequestHandler<SaveFacebookUserCommand>
    {
        private readonly IAsyncSocialRepository _facebook;
        private readonly ILogger<SaveFacebookCommandHandler> _logger;

        public SaveFacebookCommandHandler(IAsyncSocialRepository facebook, ILogger<SaveFacebookCommandHandler> logger)
        {
            _facebook = facebook;
            _logger = logger;
        }
        public async Task<Unit> Handle(SaveFacebookUserCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _facebook.RegisterUser(request);
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
