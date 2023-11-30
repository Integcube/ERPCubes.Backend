using ERPCubes.Application.Contracts.Persistence.CRM;
using MediatR;
using Microsoft.Extensions.Logging;
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
        private readonly ILogger<GetUserActivityQueryHandler> _logger;
        public GetUserActivityQueryHandler(IAsyncUserActivityRepository userActivityRepository, ILogger<GetUserActivityQueryHandler> logger)
        {
            _userActivityRepository = userActivityRepository;
            _logger = logger;
        }
        public async Task<List<GetUserActivityVm>> Handle(GetUserActivityQuery request, CancellationToken token)
        {
            try
            {
                var obj = await _userActivityRepository.GetUserActivityListAsync(request);
                return obj;
            }
            catch(Exception ex)
            {
                throw new Exception(ex.Message);
            }
          
        }
    }
}
