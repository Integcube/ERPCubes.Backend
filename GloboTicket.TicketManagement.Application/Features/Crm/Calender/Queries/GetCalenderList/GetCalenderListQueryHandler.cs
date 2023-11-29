using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Crm.Task.Queries.GetTaskList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Calender.Queries.GetCalenderList
{
    public class GetCalenderListQueryHandler : IRequestHandler<GetCalenderListQuery, List<GetCalenderListVm>>
    {
        private readonly IAsyncCalenderRepository _calenderRepository;
        private readonly ILogger<GetCalenderListQueryHandler> _logger;
        public GetCalenderListQueryHandler(IAsyncCalenderRepository calenderRepository, ILogger<GetCalenderListQueryHandler> logger)
        {
            _calenderRepository = calenderRepository;
            _logger = logger;
        }
        public async Task<List<GetCalenderListVm>> Handle(GetCalenderListQuery request, CancellationToken cancellationToken)
        {
            try
            {
                List<GetCalenderListVm> calender = new List<GetCalenderListVm>();
                calender = await _calenderRepository.GetAllList(request.Id,request.TenantId);
                return calender;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting Calender List failed due to an error : {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
        }
    }
}
