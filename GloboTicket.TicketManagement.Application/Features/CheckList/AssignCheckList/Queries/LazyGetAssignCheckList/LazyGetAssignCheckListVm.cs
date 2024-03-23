using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.AssignCheckList.Queries.LazyGetAssignCheckList
{
    public class LazyGetAssignCheckListVm
    {
        public List<LazyGetAssignCheckList> List { get; set; }
        public PaginationVm PaginationVm { get; set; }
    }


    public class LazyGetAssignCheckList
    {
        public int ExecId { get; set; }
        public int CLId { get; set; }
        public string Remarks { get; set; }
        public string CheckList { get; set; }
        public string CreatedByName { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public string Code { get; set; }

        
    }

}
