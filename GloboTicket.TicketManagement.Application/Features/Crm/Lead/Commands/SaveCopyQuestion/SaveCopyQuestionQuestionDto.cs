using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.SaveCopyQuestion
{
    public class SaveCopyQuestionDto
    {
        public int QuestionId { get; set; }
        public string Code { get; set; }
        public string Title { get; set; }
        public int Order { get; set; }
        public decimal Weightage { get; set; }
        public int TenantId { get; set; }
        public bool IsChecked { get; set; }
        
    }
}
