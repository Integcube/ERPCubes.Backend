using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmDashboard : AuditableEntity
    {
        [Key]
        public int DashboardId { get; set; }
        public string Name { get; set; } = String.Empty;
        public string Status { get; set; } = String.Empty;
        public int TenantId { get; set; }
        public int IsPrivate { get; set; }
        public string Widgets { get; set; } = String.Empty;

    }
}
