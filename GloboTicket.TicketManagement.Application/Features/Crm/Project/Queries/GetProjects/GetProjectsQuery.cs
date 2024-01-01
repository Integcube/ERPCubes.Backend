using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Project.Queries.GetProjects
{
    public class GetProjectsQuery: IRequest<List<GetProjectsVm>>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
