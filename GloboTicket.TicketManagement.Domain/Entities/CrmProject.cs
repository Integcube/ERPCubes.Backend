using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmProject: AuditableEntity
    {
        [Key]
        public int ProjectId { get; set; }
        public string Title { get; set;} = string.Empty;
        public int CompanyId { get; set;}
        public string Code { get; set; } = string.Empty;
        public decimal Budget { get; set;}
        public string Description { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public string DeletedBy { get; set; }
        public DateTime? DeletedDate { get; set; }
    }
}
