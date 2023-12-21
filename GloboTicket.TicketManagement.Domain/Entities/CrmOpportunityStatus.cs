using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmOpportunityStatus : AuditableEntity
    {
        [Key]
        public int StatusId { get; set; }
        public string StatusTitle { get; set; } = string.Empty;
        public int IsDeletable { get; set; }
        public int Order { get; set; }
        public int TenantId { get; set; }
    }
}
