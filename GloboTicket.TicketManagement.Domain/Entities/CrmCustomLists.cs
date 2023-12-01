using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmCustomLists:AuditableEntity
    {
        [Key]
        public int ListId { get; set; }
        public string ListTitle { get; set; } = String.Empty;
        public string? Filter { get; set; } = String.Empty;
        public string Type { get; set; } = String.Empty;
        public int IsPublic { get; set; }
        public int TenantId { get; set; }
    }
}
