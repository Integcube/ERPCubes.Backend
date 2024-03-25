using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Checklist.Queries.GetChecklists
{
    public class GetChecklistQuery : IRequest<List<GetChecklistVm>>
    {
        public string Id { get; set; } = String.Empty;
        public int TenantId { get; set; }
    }
}
