using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmEmail: AuditableEntity
    {
        [Key]
        public int EmailId { get; set; }
        public string Subject { get; set; } = String.Empty;
        public string Description { get; set; } = String.Empty;
        public string Reply { get; set; } = String.Empty;
        public int Id { get; set; }
     
        public DateTime? SendDate { get; set; }
        public int TenantId { get; set; }
        public int IsSuccessful { get; set; }
        public int ContactTypeId { get; set; }
    }
}
