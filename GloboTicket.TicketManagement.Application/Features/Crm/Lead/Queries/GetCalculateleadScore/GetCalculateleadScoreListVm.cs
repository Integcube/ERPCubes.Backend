using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetCalculateleadScore
{
    public class GetCalculateleadScoreListVm
    {
     
        public decimal Rating { get; set; }
        public decimal Weightage { get; set; }
        public int LeadId { get; set; }
        public int QuestionId { get; set; }

    }
}
