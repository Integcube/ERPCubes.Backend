using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetStatusWiseLeads
{
    public class GetStatusWiseLeadsVm
    {
        public int StatusId { get; set; }
        public string StatusTitle { get; set; }
        public int Order { get; set; }
        public List<GetStatusWiseLeadsDto> Leads { get; set; }
    }
}
