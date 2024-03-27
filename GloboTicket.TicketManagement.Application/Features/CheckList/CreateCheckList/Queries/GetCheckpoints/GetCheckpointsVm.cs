using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.CreateCheckList.Queries.GetCheckpoints
{
    public class GetCheckpointsVm
    {
        public int CLId { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public int DueDays { get; set; }
        public int IsRequired { get; set; }
        public int? Priority { get; set; }
        public int CPId { get; set; }
    }
}
