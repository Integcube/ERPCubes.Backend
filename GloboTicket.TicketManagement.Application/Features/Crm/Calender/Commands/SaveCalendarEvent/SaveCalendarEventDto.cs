using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Calender.Commands.SaveCalendarEvent
{
    public class SaveCalendarEventDto
    {
        public DateTime Start { get; set; }
        public DateTime End { get; set; }
        public String Title { get; set; }=String.Empty;
        public int Id { get; set; }
        public bool AllDay { get; set; }
        public int Type { get; set; }

    }
}
