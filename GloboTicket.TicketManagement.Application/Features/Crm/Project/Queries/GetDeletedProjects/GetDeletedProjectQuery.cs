using ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetDeletedForms;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Project.Queries.GetDeletedProjects
{
    public class GetDeletedProjectQuery : IRequest<List<GetDeletedProjectVm>>
    {
        public string Id { get; set; } = String.Empty;
        public int TenantId { get; set; }
    }
}
