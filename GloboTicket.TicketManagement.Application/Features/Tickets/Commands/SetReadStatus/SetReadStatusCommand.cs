using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tickets.Commands.SetReadStatus
{
    public class SetReadStatusCommand : IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; }
        public int TicketId { get; set; }
    }
   
}
