using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Project.Commands.DeleteProject
{
    public class DeleteProjectCommand: IRequest
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public int ProjectId { get; set; }
    }
}
