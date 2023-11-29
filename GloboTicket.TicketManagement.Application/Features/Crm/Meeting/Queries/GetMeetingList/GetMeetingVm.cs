using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Meeting.Queries.GetMeetingList
{
    public class GetMeetingVm
    {
        public int MeetingId { get; set; }
        public string Subject { get; set; } = String.Empty;
        public string Note { get; set; } = String.Empty;
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public string CreatedBy { get; set; } = string.Empty;
        public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
    }
}
