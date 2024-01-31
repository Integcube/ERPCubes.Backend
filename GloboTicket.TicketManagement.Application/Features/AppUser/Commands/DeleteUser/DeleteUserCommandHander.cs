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

namespace ERPCubes.Application.Features.AppUser.Commands.DeleteUser
{
    public class DeleteUserCommandHander : IRequestHandler<DeleteUserCommand>
    {
        private readonly IAsyncUserRepository _usersRepository;
        private readonly ILogger<DeleteUserCommandHander> _logger;

        public DeleteUserCommandHander(IAsyncUserRepository usersRepository, ILogger<DeleteUserCommandHander> logger)
        {
            _usersRepository = usersRepository;
            _logger = logger;
        }

        public async Task<Unit> Handle(DeleteUserCommand request, CancellationToken cancellationToken)
        {
            try
            {
                await _usersRepository.DeleteUser(request);
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
