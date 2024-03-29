using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.ExecuteCheckList.Commands.GetAssignedCheckList
{
    public class GetAssignedCheckListVm
    {
        public string Title { get; set; }
        public string CreatedBy { get; set; }
        public string Description { get; set; }
        public DateTime AssignedDate { get; set; }
        public int CLId { get; set; }
        public int ExecId { get; set; }
        public string Remarks { get; set; }
        public int  Status { get; set; }
        public string Referenceno { get; set; }
        public string Code { get; set; }
        

    }
}
