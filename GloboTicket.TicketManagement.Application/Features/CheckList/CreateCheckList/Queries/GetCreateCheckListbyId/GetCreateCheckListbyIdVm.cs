using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.CheckList.CreateCheckList.Queries.GetCreateCheckListbyId
{
    public class GetCreateCheckListbyIdVm
    {
        public int ClId { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
    }
}
