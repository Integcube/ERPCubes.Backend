using ERPCubes.Application.Contracts.Persistence.CRM;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.UserActivity.Queries.GetUserActivity
{
    public class GetUserActivityQueryHandler : IRequestHandler<GetUserActivityQuery, List<GetUserActivityVm>>
    {
        private readonly IAsyncUserActivityRepository _userActivityRepository;
        public GetUserActivityQueryHandler(IAsyncUserActivityRepository userActivityRepository)
        {
            _userActivityRepository = userActivityRepository;
        }
        public async Task<List<GetUserActivityVm>> Handle(GetUserActivityQuery request, CancellationToken token)
        {
            var obj = await _userActivityRepository.GetUserActivityListAsync(request);
            return obj;
        }
    }
}
