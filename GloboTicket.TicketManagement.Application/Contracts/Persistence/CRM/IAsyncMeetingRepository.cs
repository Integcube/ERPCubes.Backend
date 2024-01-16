using ERPCubes.Application.Features.Crm.Call.Commands.DeleteCall;
using ERPCubes.Application.Features.Crm.Call.Commands.SaveCall;
using ERPCubes.Application.Features.Crm.Call.Queries.GetCallList;
using ERPCubes.Application.Features.Crm.Email.Commands.DeleteEmail;
using ERPCubes.Application.Features.Crm.Meeting.Commands.DeleteMeeting;
using ERPCubes.Application.Features.Crm.Meeting.Commands.SaveMeeting;
using ERPCubes.Application.Features.Crm.Meeting.Queries.GetMeetingList;
using ERPCubes.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Contracts.Persistence.CRM
{
    public interface IAsyncMeetingRepository : IAsyncRepository<CrmMeeting>
    {
        Task<List<GetMeetingVm>> GetAllList(string Id, int TenantId, int ContactTypeId, int ContactId);
        Task DeleteMeeting(DeleteMeetingCommand meetingId);
        Task SaveMeeting(SaveMeetingCommand meeting);
    }
}
