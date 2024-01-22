using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Tickets.Queries.GetTicketTypeList
{
    public class GetTicketTypeListQuery:IRequest<List<GetTicketTypeListVm>>
    {
        public int MyProperty { get; set; }
        public string Id { get; set; }
    }
}
