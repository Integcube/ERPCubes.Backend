using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tickets.Queries.GetAllTickets
{
    public class GetAllTicketsQuery:IRequest<List<GetAllTicketsVm>>
    {
        public int TenantId { get; set; }
        public string Id { get; set; }
    }
}
