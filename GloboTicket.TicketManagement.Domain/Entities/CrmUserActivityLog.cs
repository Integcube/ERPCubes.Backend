using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmUserActivityLog : AuditableEntity
    {
        [Key]
        public int ActivityId { get; set; }
        [Required]
        public string UserId { get; set; } = string.Empty;
        [Required]
        public int ActivityType { get; set; }
        [Required]
        public int ActivityStatus { get; set; }
        [Required]
        public string Detail { get; set; } = string.Empty;
        [Required]
        public int TenantId { get; set; }

    }
}
