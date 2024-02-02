using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetScoreListQuery
{
    public class GetScoreListVm
    {
        public int QuestionId { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Code { get; set; }
        public int Order { get; set; }
        public decimal Rating { get; set; }
        public int TenantId { get; set; }
        public decimal Weightage { get; set; }
      
        
    }
}
