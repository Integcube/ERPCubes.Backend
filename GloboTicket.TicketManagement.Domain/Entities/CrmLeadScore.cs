using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmLeadScore
    {
        [Key]
        public int ScoreId { get; set; }
        public int LeadId { get; set; }
        public int QuestionId { get; set; }
        public decimal Rating { get; set; }
        public string CreatedBy { get; set; } 
        public DateTime CreatedDate { get; set; }
    }
}
