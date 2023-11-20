using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmLeadSource : AuditableEntity
    {
        [Key]
        public int SourceId { get; set; }
        public string SourceTitle { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
