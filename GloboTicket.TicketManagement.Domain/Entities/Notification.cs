using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class Notification:AuditableEntity
    {
        [Key]
        public int NotificationId { get; set; }
        public string Icon { get; set; }
        public string Image { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Link { get; set; }
        public string UseRouter { get; set; }
        public int Read { get; set; }
        public int TenantId { get; set; }
    }
}
