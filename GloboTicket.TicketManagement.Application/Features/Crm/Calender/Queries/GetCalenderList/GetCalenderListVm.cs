using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Calender.Queries.GetCalenderList
{
    public class GetCalenderListVm
    {
        public int Id { get; set; }
        public string UserId { get; set; } = String.Empty;
        public string Title { get; set; } = String.Empty;
        public int Type { get; set; }
        public DateTime? Start { get; set; }
        public DateTime? End { get; set; }
        public bool AllDay { get; set; }
    }
}
