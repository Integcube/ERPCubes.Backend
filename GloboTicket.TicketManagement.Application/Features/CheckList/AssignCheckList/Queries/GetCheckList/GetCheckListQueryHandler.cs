using AutoMapper;
using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Application.Features.AppUser.Queries.LazyGetUserList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckList;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ERPCubes.Application.FeaturesCheckList.AssignCheckList.Queries.GetCheckList
{
    public class GetCheckListQueryHandler : IRequestHandler<GetCheckListQuery, List<GetCheckListVm>>
    {
        private readonly IAsyncAssignCheckListRepository _userRepository;
        private readonly IMapper _mapper;
        private readonly ILogger _logger;
        public GetCheckListQueryHandler(IAsyncAssignCheckListRepository userRepository, IMapper mapper)
        {
            _userRepository = userRepository;
            _mapper = mapper;
        }
        public async Task<List<GetCheckListVm>> Handle(GetCheckListQuery request, CancellationToken cancellationToken)
        {
            List<GetCheckListVm> Users = new List<GetCheckListVm>();
            try
            {
                Users = await _userRepository.GetCheckList(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting User List failed due to an error : {ex.Message}");
            }
            return Users;
        }
    }

}
