using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Project.Commands.RestoreProject
{
    public class RestoreProjectCommand : IRequest
    {
        public int ProjectId { get; set; }
    }
}
