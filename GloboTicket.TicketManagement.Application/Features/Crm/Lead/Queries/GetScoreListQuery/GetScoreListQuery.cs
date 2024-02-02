using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetScoreListQuery
{
    public class GetScoreListQuery : IRequest<List<GetScoreListVm>>
    {
        public int TenantId { get; set; }
        public int LeadId { get; set; } 

    }
}
