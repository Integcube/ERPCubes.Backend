using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmTeamMember:AuditableEntity
    {
        [Key]
        public int TeamMemberId { get; set; }
        public string UserId { get; set; } = string.Empty;
        public int TeamId { get; set; }
        public int TenantId { get; set; }
    }
}
