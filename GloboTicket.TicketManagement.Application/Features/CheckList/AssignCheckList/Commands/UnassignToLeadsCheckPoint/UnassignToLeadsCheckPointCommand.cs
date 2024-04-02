using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.UnassignToLeadsCheckPoint
{
    public class UnassignToLeadsCheckPointCommand : IRequest
    {
        public string Id { get; set; }
        public int TenantId { get; set; }
        public int CLId { get; set; }

    }
}
