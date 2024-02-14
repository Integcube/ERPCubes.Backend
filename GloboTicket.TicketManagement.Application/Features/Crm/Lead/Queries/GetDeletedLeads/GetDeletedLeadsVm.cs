using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetDeletedLeads
{
    public class GetDeletedLeadsVm
    {
        public int Id { get; set; }
        //public string Id { get; set; } = string.Empty;
        public string Title { get; set; } = string.Empty;
        public string DeletedBy { get; set; }
        public DateTime? DeletedDate { get; set; }
    }
}
