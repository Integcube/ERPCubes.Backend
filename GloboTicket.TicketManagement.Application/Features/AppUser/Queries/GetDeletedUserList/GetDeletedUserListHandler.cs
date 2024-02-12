using AutoMapper;
using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.AppUser.Queries.GetDeletedUserList
{
    public class GetDeletedUserListHandler : IRequestHandler<GetDeletedUserListQuery, List<GetDeletedUserListVm>>
    {
        private readonly IAsyncUserRepository _userRepository;
        private readonly IMapper _mapper;
        private readonly ILogger _logger;
        public GetDeletedUserListHandler(IAsyncUserRepository userRepository, IMapper mapper)
        {
            _userRepository = userRepository;
            _mapper = mapper;
        }

        public async Task<List<GetDeletedUserListVm>> Handle(GetDeletedUserListQuery request, CancellationToken cancellationToken)
        {
            List<GetDeletedUserListVm> Users = new List<GetDeletedUserListVm>();
            try
            {
                Users = await _userRepository.GetDeletedUsers(request.TenantId, request.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting User List failed due to an error : {ex.Message}");
            }
            return Users;
        }
    }
}
