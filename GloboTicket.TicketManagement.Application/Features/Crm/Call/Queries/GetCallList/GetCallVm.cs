using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Call.Queries.GetCallList
{
    public class GetCallVm
    {
        public int CallId { get; set; }
        public string Subject { get; set; } = String.Empty;
        public string Response { get; set; } = String.Empty;
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public string CreatedBy {  get; set; }=String.Empty;
        public DateTime? CreatedDate { get; set; }
    }
}
