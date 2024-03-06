using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadSourceByCount
{
    public class GetLeadSourceByCountVm
    {
        public string Source { get; set; }
        public int TotalLeads { get; set; }
    }
}
