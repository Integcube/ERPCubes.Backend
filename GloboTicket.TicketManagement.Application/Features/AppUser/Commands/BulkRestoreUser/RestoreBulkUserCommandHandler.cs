using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.AppUser.Commands.DeleteUser;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.AppUser.Commands.BulkRestoreUser
{
    public class RestoreBulkUserCommandHandler : IRequestHandler<RestoreBulkUserCommand>
    {
        private readonly IAsyncUserRepository _usersRepository;
        private readonly ILogger<RestoreBulkUserCommandHandler> _logger;

        public RestoreBulkUserCommandHandler(IAsyncUserRepository usersRepository, ILogger<RestoreBulkUserCommandHandler> logger)
        {
            _usersRepository = usersRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(RestoreBulkUserCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _usersRepository.RestoreBulkUser(request);
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
