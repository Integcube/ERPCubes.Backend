using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmFormResults: AuditableEntity
    {
        [Key]
        public int ResultId { get; set; }
        public int FormId { get; set; }
        public int FieldId { get; set; }
        public string Result { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
