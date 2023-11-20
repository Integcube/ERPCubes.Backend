using AutoMapper;
using ERPCubes.Application.Contracts.Persistence;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.AppUser.Queries.GetUserList
{
    public class GetUserListQueryHandler : IRequestHandler<GetUserListQuery, List<GetUserListVm>>
    {
        private readonly IAsyncUserRepository _userRepository;
        private readonly IMapper _mapper;
        private readonly ILogger _logger;
        public GetUserListQueryHandler(IAsyncUserRepository userRepository, IMapper mapper)
        {
            _userRepository = userRepository;
            _mapper = mapper;
        }
        public async Task<List<GetUserListVm>> Handle(GetUserListQuery request, CancellationToken cancellationToken)
        {
            List<GetUserListVm> Users = new List<GetUserListVm>();
            try
            {
                Users = await _userRepository.GetUserList(request.TenantId, request.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting User List failed due to an error : {ex.Message}");
            }
            return Users;
        }
    }
}
