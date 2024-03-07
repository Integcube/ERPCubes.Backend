using AutoMapper;
using ERPCubes.Application.Contracts.Persistence;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.AppUser.Queries.LazyGetUserList
{
    public class LazyGetUserListQueryHandler : IRequestHandler<LazyGetUserListQuery, LazyGetUserListVm>
    {
        private readonly IAsyncUserRepository _userRepository;
        private readonly IMapper _mapper;
        private readonly ILogger _logger;
        public LazyGetUserListQueryHandler(IAsyncUserRepository userRepository, IMapper mapper)
        {
            _userRepository = userRepository;
            _mapper = mapper;
        }
           public async Task<LazyGetUserListVm> Handle(LazyGetUserListQuery request, CancellationToken cancellationToken)
            {
            LazyGetUserListVm Users = new LazyGetUserListVm();
            try
            {
                Users = await _userRepository.LazyGetUserList(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting User List failed due to an error : {ex.Message}");
            }
            return Users;
        }
    }
}
