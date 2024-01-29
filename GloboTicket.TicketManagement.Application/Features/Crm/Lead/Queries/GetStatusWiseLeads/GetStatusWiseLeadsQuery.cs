using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetStatusWiseLeads
{
    public class GetStatusWiseLeadsQuery:IRequest<List<GetStatusWiseLeadsVm>>
    {
        public string Id { get; set; }
        public int TenantId { get; set; }
    }
}
