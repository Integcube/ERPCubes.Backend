using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmTeam:AuditableEntity
    {

        [Key]
        public int TeamId { get; set; }
        public int TenantId { get; set; }
        public string Name { get; set; } = string.Empty;
        public string TeamLeader { get; set; } = string.Empty;
    }
}
