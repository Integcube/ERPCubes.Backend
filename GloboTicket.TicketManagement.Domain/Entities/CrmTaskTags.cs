using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmTaskTags:AuditableEntity
    {
        [Key]
        public int TaskTagsId { get; set; }
        public int TaskId { get; set; }
        public int TagId { get; set; }
        public int TenantId { get; set; }
    }
}
