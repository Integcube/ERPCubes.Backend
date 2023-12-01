using ERPCubes.Application.Features.Crm.Task.Queries.GetTaskList;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Call.Queries.GetCallList
{
    public class GetCallListQuery : IRequest<List<GetCallVm>>
    {
        public string Id { get; set; } = String.Empty;
        public int TenantId { get; set; }
        public int LeadId { get; set; }
        public int CompanyId { get; set; }

    }
}
