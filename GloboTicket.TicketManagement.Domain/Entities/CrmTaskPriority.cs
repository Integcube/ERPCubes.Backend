using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmTaskPriority:AuditableEntity
    {
        [Key]
        public int PriorityId { get; set; }
        public string PriorityTitle { get; set; } = String.Empty;
    }
}
