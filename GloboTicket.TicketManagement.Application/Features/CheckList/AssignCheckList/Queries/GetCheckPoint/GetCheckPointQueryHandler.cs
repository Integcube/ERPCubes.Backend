using AutoMapper;
using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Application.Features.AppUser.Queries.LazyGetUserList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckPoint;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ERPCubes.Application.FeaturesCheckList.AssignCheckList.Queries.GetCheckList
{
    public class GetCheckPointQueryHandler : IRequestHandler<GetCheckPointQuery, List<GetCheckPointVm>>
    {
        private readonly IAsyncAssignCheckListRepository _userRepository;
        private readonly IMapper _mapper;
        private readonly ILogger _logger;
        public GetCheckPointQueryHandler(IAsyncAssignCheckListRepository userRepository, IMapper mapper)
        {
            _userRepository = userRepository;
            _mapper = mapper;
        }
        public async Task<List<GetCheckPointVm>> Handle(GetCheckPointQuery request, CancellationToken cancellationToken)
        {
            List<GetCheckPointVm> Users = new List<GetCheckPointVm>();
            try
            {
                Users = await _userRepository.GetCheckPoint(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting User List failed due to an error : {ex.Message}");
            }
            return Users;
        }
    }

}
