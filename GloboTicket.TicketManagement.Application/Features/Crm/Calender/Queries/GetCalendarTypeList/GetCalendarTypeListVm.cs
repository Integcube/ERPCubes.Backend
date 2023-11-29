using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Calender.Queries.GetCalendarTypeList
{
    public class GetCalendarTypeListVm
    {
        public int TypeId { get; set; }
        public string TypeTitle { get; set; } = String.Empty;
    }
}
