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
        public int ActivityStatus { get; set; }
        public string Detail { get; set; } = string.Empty;
        public DateTime Date { get; set; }
        public string Icon { get; set; } = string.Empty;


    }
}
