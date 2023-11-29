using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Calender.Queries.GetCalenderList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Calender.Queries.GetCalendarTypeList
{

    public class GetCalendarTypeListQueryHandler : IRequestHandler<GetCalendarTypeListQuery, List<GetCalendarTypeListVm>>
    {
        private readonly IAsyncCalenderRepository _calenderRepository;
        private readonly ILogger<GetCalendarTypeListQueryHandler> _logger;
        public GetCalendarTypeListQueryHandler(IAsyncCalenderRepository calenderRepository, ILogger<GetCalendarTypeListQueryHandler> logger)
        {
            _calenderRepository = calenderRepository;
            _logger = logger;
        }
        public async Task<List<GetCalendarTypeListVm>> Handle(GetCalendarTypeListQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetCalendarTypeListVm> calender = new List<GetCalendarTypeListVm>();
                calender = await _calenderRepository.GetCalendarEventType(request);
                return calender;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Calender Type List failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
