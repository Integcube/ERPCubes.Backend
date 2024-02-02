using ERPCubes.Application.Features.Crm.Lead.Queries.GetScoreListQuery;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.SaveLeadScore
{
    public class SaveLeadScoreCommand : IRequest
    {

        public List<GetScoreListVm> Leads { get; set; }
        public int TenantId { get; set; }
        public int leadId { get; set; }
        public string Id { get; set; }
        
    }
}
