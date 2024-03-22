using AutoMapper;
using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.LazyGetAssignCheckList;
using MediatR;
using Microsoft.Extensions.Logging;


namespace ERPCubes.Application.FeaturesCheckList.AssignCheckList.Queries.LazyGetUserList
{
    public class LazyGetAssignCheckListQueryHandler : IRequestHandler<LazyGetAssignCheckListQuery, LazyGetAssignCheckListVm>
    {
        private readonly IAsyncAssignCheckListRepository _checkListRepository;
        private readonly IMapper _mapper;
        private readonly ILogger _logger;
        public LazyGetAssignCheckListQueryHandler(IAsyncAssignCheckListRepository CheckListRepository, IMapper mapper)
        {
            _checkListRepository = CheckListRepository;
            _mapper = mapper;
        }
           public async Task<LazyGetAssignCheckListVm> Handle(LazyGetAssignCheckListQuery request, CancellationToken cancellationToken)
            {
            LazyGetAssignCheckListVm Users = new LazyGetAssignCheckListVm();
            try
            {
                Users = await _checkListRepository.LazyGetAssignCheckList(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting User List failed due to an error : {ex.Message}");
            }
            return Users;
        }
    }
}
