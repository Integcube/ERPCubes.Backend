using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.GetCheckPoint
{
    public class GetCheckPointVm
    {
        public int CLId { get; set; }
        public string Title { get; set; }
        public int DueDays { get; set; }
        public int IsRequired { get; set; }
        public string AssignTo { get; set; }
        public int ExecId { get; set; }

        
    }


}
