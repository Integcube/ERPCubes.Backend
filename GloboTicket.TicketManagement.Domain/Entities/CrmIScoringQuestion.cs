using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    using ERPCubes.Domain.Common;
    using System;
    using System.ComponentModel.DataAnnotations;

    public class CrmIScoringQuestion:AuditableEntity
    {
        [Key]
        public int QuestionId { get; set; }
        public string Code { get; set; }
        public string Title { get; set; }
        public int Order { get; set; }
        public int ProductId { get; set; }
        public decimal Weightage { get; set; }
        public int TenantId { get; set; }
        
    }

}
