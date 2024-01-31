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
        public string CreatedByName { get; set; } = String.Empty;
        public int ReasonId { get; set; }
        public DateTime? DueDate { get; set; }
        public int TaskId { get; set; }
        public int IsTask { get; set; }
        public DateTime CallDate { get; set; }
        
    }
}
