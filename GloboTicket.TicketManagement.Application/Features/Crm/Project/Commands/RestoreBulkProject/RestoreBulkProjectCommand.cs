using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Project.Commands.RestoreBulkProject
{
    public class RestoreBulkProjectCommand : IRequest
    {
        public List<int> ProjectId { get; set; }
    }
}
