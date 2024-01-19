using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.FormBuilder.Queries.GetFieldTypes
{
    public class GetFieldTypesVm
    {
        public int TypeId { get; set; }
        public string TypeName { get; set; }
        public string TypeLabel { get; set; }
        public string Icon { get; set; }
    }
}
