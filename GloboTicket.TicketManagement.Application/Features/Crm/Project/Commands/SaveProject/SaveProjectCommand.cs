using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Project.Commands.SaveProject
{
    public class SaveProjectCommand: IRequest
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public int ProjectId { get; set; }
        public string Title { get; set; } = string.Empty;
        public int CompanyId { get; set; }
        public string Code { get; set; } = string.Empty;
        public decimal Budget { get; set; }
        public string Description { get; set; } = string.Empty;

    }
}
