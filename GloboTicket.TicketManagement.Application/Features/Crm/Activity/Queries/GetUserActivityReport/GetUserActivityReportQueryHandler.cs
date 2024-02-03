using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Activity.Queries.GetUserActivityReport;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Activity.Queries.GetUserActivityReport
{
    public class GetUserActivityReportQueryHandler: IRequestHandler<GetUserActivityReportQuery, List<GetUserActivityReportVm>>
    {
        private readonly IAsyncUserActivityRepository _userActivityRepository;
        private readonly ILogger<GetUserActivityReportQueryHandler> _logger;
        public GetUserActivityReportQueryHandler(IAsyncUserActivityRepository userActivityRepository, ILogger<GetUserActivityReportQueryHandler> logger)
        {
            _userActivityRepository = userActivityRepository;
            _logger = logger;
        }
        public async Task<List<GetUserActivityReportVm>> Handle(GetUserActivityReportQuery request, CancellationToken token)
        {
            try
            {
                List<GetUserActivityReportVm> ActivityReport = new List<GetUserActivityReportVm>();
                ActivityReport = await _userActivityRepository.GetUserActivityReport(request);
                return ActivityReport;
            }
            catch(Exception ex)
            {
                _logger.LogError($"Getting User Activity List for Report has failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }

}
