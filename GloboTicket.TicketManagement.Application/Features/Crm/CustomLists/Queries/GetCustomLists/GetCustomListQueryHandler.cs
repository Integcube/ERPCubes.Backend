using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Logging;

namespace ERPCubes.Application.Features.Crm.CustomLists.Queries.GetCustomLists
{
    public class GetCustomListQueryHandler : IRequestHandler<GetCustomListQuery, List<GetCustomListVm>>
    {
        private readonly IAsyncCustomListRepository _customRepository;
        private readonly ILogger<GetCustomListQueryHandler> _logger;
        public GetCustomListQueryHandler(IAsyncCustomListRepository customRepository, ILogger<GetCustomListQueryHandler> logger)
        {
            _customRepository = customRepository;
            _logger = logger;
        }
        public async Task<List<GetCustomListVm>> Handle(GetCustomListQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetCustomListVm> CustomList = await _customRepository.GetAllCustomLists(request.TenantId, request.Id, request.Type);
                return CustomList;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Custom {request.Type} List failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
