using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.UserActivity.Queries.GetUserActivity
{
    public class GetUserActivityVm
    {
        public int ActivityId { get; set; }
        public string UserId { get; set; } = string.Empty;
        public string ActivityType { get; set; } = string.Empty;
        public int ActivityTypeId { get; set; }
        public int ActivityStatus { get; set; }
        public string Detail { get; set; } = string.Empty;
        public DateTime CreatedDate { get; set; }
        public string CreatedBy { get; set; } = string.Empty;
        public string Icon { get; set; } = string.Empty;
        public string UserName { get; set; }
        
    }
}
