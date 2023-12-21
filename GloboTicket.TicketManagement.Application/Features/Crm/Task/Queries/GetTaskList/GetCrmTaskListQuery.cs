using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Queries.GetTaskList
{
    public class GetCrmTaskListQuery:IRequest<List<GetCrmTaskListVm>>
    {
        public int TenantId { get; set; }
        public int CompanyId { get; set; }
        public int LeadId { get; set; }
        public int OpportunityId { get; set; }
        public string Id { get; set; }=String.Empty;
    }
}
