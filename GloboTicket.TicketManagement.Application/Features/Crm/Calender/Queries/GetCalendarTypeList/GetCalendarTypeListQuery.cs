using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Calender.Queries.GetCalendarTypeList
{
    public class GetCalendarTypeListQuery:IRequest<List<GetCalendarTypeListVm>>
    {
        public int TenantId { get; set; }
        public string Id { get; set; }=String.Empty;

    }
}
