using AutoMapper;
using ERPCubes.Application.Contracts.Persistence;
using ERPCubes.Application.Contracts.Persistence.CheckList;
using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Features.AppUser.Queries.GetUserList;
using ERPCubes.Application.Features.AppUser.Queries.LazyGetUserList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckList;
using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckPoint;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetCheckPoint
{
    public class GetCheckPointQueryHandler : IRequestHandler<GetCheckPointLeadQuery, List<GetCheckPointLeadVm>>
    {
        private readonly IAsyncLeadRepository _userRepository;
        private readonly IMapper _mapper;
        private readonly ILogger _logger;
        public GetCheckPointQueryHandler(IAsyncLeadRepository userRepository, IMapper mapper)
        {
            _userRepository = userRepository;
            _mapper = mapper;
        }
        public async Task<List<GetCheckPointLeadVm>> Handle(GetCheckPointLeadQuery request, CancellationToken cancellationToken)
        {
            List<GetCheckPointLeadVm> Users = new List<GetCheckPointLeadVm>();
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
