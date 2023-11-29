using ERPCubes.Application.Contracts.Persistence.CRM;
using ERPCubes.Application.Exceptions;
using ERPCubes.Application.Features.Product.Queries.GetProductList;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Meeting.Queries.GetMeetingList
{
    public class GetMeetingListQueryHandler : IRequestHandler<GetMeetingListQuery, List<GetMeetingVm>>
    {
        private readonly IAsyncMeetingRepository _meetingRepository;
        private readonly ILogger<GetMeetingListQueryHandler> _logger;

        public GetMeetingListQueryHandler(IAsyncMeetingRepository meetingRepository, ILogger<GetMeetingListQueryHandler> logger)
        {
            _meetingRepository = meetingRepository;
            _logger = logger;
        }

        public async Task<List<GetMeetingVm>> Handle(GetMeetingListQuery request, CancellationToken cancellationToken)
        {
            List<GetMeetingVm> meetings = new List<GetMeetingVm>();
            try
            {
                meetings = await _meetingRepository.GetAllList(request.Id, request.TenantId);
            }
            catch (Exception ex)
            {
                _logger.LogError($"Getting about meeting list failed due to an error: {ex.Message}");
                throw new BadRequestException(ex.Message);
            }
            return meetings;
        }
    }
}
