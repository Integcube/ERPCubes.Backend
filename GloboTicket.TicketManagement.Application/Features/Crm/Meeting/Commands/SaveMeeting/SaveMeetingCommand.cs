using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Meeting.Commands.SaveMeeting
{
    public class SaveMeetingCommand : IRequest
    {
        public int MeetingId { get; set; }
        public string Subject { get; set; } = String.Empty;
        public string Note { get; set; } = String.Empty;
        public string Id { get; set; } = String.Empty;
        public int CompanyId { get; set; }
        public int LeadId { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public int TenantId { get; set; }
        public string CreatedBy { get; set; } = string.Empty;
        public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
    }
}
