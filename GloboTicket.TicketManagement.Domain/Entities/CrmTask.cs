using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmTask:AuditableEntity
    {
        [Key]
        public int TaskId { get; set; }
        public string Title { get; set; } = String.Empty;
        public DateTime? DueDate { get; set; }
        public int Priority { get; set; }
        public int Status { get; set; }
        public string Description { get; set; } = String.Empty;
        public string TaskOwner { get; set; } = String.Empty;
        public int Id { get; set; }
        public int IsCompany { get; set; }
        public int IsLead { get; set; }
        public int TenantId { get; set; }
        public string Type { get; set; } = String.Empty;
        public int Order { get; set; }
    }
}
