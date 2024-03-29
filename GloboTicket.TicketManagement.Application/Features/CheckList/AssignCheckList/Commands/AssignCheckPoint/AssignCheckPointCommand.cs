using ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckPoint;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.AssignCheckList.Commands.AssignCheckPoint
{
    public class AssignCheckPointCommand : IRequest
    {

        public List<GetCheckPointVm> List { get; set; }
        public string Id { get; set; }
        public int TenantId { get; set; }
        public int CLId { get; set; }
        public string Remarks { get; set; }
        public int ExecId { get; set; }
        public string Referenceno { get; set; }
        
    }


}
