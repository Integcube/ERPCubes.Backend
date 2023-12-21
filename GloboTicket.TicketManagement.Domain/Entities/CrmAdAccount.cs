using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmAdAccount : AuditableEntity
    {
        [Key]
        public int AccountId { get; set; }
        public string Title { get; set; } = String.Empty;
        public int IsSelected { get; set; }
        public string SocialId { get; set; } = String.Empty;
        public int TenantId { get; set; }

    }
}
