using ERPCubes.Application.Features.Notes.Queries.GetDeletedNotes;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Task.Queries.GetDeletedTasks
{
    public class GetDeletedTaskQuery : IRequest<List<GetDeletedTaskVm>>
    {
        public string Id { get; set; } = String.Empty;
        public int TenantId { get; set; }
    }
}
