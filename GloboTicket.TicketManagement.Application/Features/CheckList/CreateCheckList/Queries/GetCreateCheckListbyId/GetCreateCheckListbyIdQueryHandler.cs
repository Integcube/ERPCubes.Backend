using AutoMapper;
using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetExcutedCheckListbyId;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.CreateCheckList.Queries.GetCreateCheckListbyId
{
    public class GetCreateCheckListbyIdQueryHandler : IRequestHandler<GetCreateCheckListbyIdQuery, GetCreateCheckListbyIdVm>
    {
        private readonly IAsyncCreateCheckListRepository _userRepository;
        private readonly IMapper _mapper;
        private readonly ILogger<GetCreateCheckListbyIdQueryHandler> _logger;

        public GetCreateCheckListbyIdQueryHandler(IAsyncCreateCheckListRepository userRepository, IMapper mapper, ILogger<GetCreateCheckListbyIdQueryHandler> logger)
        {
            _userRepository = userRepository ?? throw new ArgumentNullException(nameof(userRepository));
            _mapper = mapper ?? throw new ArgumentNullException(nameof(mapper));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public async Task<GetCreateCheckListbyIdVm> Handle(GetCreateCheckListbyIdQuery request, CancellationToken cancellationToken)
        {
            GetCreateCheckListbyIdVm result = new GetCreateCheckListbyIdVm();

            try
            {
                var executionDetails = await _userRepository.GetCreateCheckListbyId(request);

                result = _mapper.Map<GetCreateCheckListbyIdVm>(executionDetails);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Failed to retrieve executed checklist: {ex.Message}");
            }

            return result;
        }
    }
}
