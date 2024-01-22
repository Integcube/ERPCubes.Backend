using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tickets.Queries.GetTicketStatusList
{
    public class GetTicketStatusListVm
    {
        public int TicketStatusId { get; set; }
        public string StatusName { get; set; }
        public string Class { get; set; }
    }
}
