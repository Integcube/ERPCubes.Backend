using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.AppUser.Commands.UpdateUser
{
    public class UpdateUserCommandHander : IRequestHandler<UpdateUserCommand>
    {
        private readonly IAsyncUserRepository _usersRepository;
        private readonly ILogger<UpdateUserCommandHander> _logger;

        public UpdateUserCommandHander(IAsyncUserRepository usersRepository, ILogger<UpdateUserCommandHander> logger)
        {
            _usersRepository = usersRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(UpdateUserCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _usersRepository.UpdateUser(request);
                return Unit.Value;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting about company list failed due to an error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
