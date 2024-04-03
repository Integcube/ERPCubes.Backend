using AutoMapper;
using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetExcutedCheckListbyId;
using MediatR;
using Microsoft.Extensions.Logging;


namespace ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetExcutedCheckListbyId
{
    public class GetExcutedCheckListbyIdQueryHandler : IRequestHandler<GetExcutedCheckListbyIdQuery, GetExcutedCheckListbyIdVm>
    {
        private readonly IAsyncAssignCheckListRepository _userRepository;
        private readonly IMapper _mapper;
        private readonly ILogger<GetExcutedCheckListbyIdQueryHandler> _logger;

        public GetExcutedCheckListbyIdQueryHandler(IAsyncAssignCheckListRepository userRepository, IMapper mapper, ILogger<GetExcutedCheckListbyIdQueryHandler> logger)
        {
            _userRepository = userRepository;
            _mapper = mapper;
            _logger = logger;
        }

        public async Task<GetExcutedCheckListbyIdVm> Handle(GetExcutedCheckListbyIdQuery request, CancellationToken cancellationToken)
        {
            GetExcutedCheckListbyIdVm users = new GetExcutedCheckListbyIdVm();
            try
            {
                users = await _userRepository.GetExcutedCheckListbyId(request);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting User List failed due to an error: {ex.Message}");
            }
            return users;
        }
    }
}
