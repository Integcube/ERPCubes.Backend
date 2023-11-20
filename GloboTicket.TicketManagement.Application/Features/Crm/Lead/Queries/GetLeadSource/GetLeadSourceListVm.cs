using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSource
{
    public class GetLeadSourceListVm
    {
        public int SourceId { get; set; }
        public string SourceTitle { get; set; } = string.Empty;
    }
}
