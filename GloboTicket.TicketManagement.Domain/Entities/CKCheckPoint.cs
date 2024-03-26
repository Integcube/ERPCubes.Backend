using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ERPCubes.Domain.Common;
using System;
using System.ComponentModel.DataAnnotations;
namespace ERPCubes.Domain.Entities
{
   

    public class CKCheckPoint: AuditableEntity
    {
        [Key]
        public int CPId { get; set; }
        public int CLId { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public int DueDays { get; set; }
        public int IsRequired { get; set; }
        public int TenantId { get; set; }
        public int Priority { get; set; }
    }

}
