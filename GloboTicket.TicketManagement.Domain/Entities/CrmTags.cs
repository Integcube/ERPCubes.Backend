using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmTags : AuditableEntity
    {
        [Key]
        public int TagId { get; set; }
        public string TagTitle { get; set; } = string.Empty;
        public int TenantId { get; set; }

    }
}
