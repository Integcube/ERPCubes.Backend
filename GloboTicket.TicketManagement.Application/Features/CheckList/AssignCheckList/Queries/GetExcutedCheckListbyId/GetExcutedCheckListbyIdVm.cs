using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetExcutedCheckListbyId
{
    public class GetExcutedCheckListbyIdVm
    {
        public int ExecId { get; set; }
        public int CLId { get; set; }
        public string Remarks { get; set; }
        public int TenantId { get; set; }
        public string Code { get; set; }
        public string Referenceno { get; set; }

    }


}
