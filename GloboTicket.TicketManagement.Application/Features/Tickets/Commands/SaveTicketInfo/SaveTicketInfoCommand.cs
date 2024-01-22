using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tickets.Commands.SaveTicketInfo
{
    public class SaveTicketInfoCommand:IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; }
        public int Priority { get; set; }
        public string AssigneeId { get; set; }
        public int Type { get; set; }
        public int Status { get; set; }
        public string Notes { get; set; }
        public int TicketId { get; set; }
    }
}
