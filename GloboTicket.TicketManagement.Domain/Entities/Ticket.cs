using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class Ticket:AuditableEntity
    {
        [Key]
        public int TicketId { get; set; }
        public string SocialMediaPlatform { get; set; }
        public string CustomerId { get; set; }
        public DateTime Timestamp { get; set; }
        public int Status { get; set; }
        public string AssigneeId { get; set; }
        public int Priority { get; set; }
        public int Type { get; set; }
        public string Category { get; set; }
        public string ResolutionStatus { get; set; }
        public DateTime DueDate { get; set; }
        public DateTime RecentlyActive { get; set; }
        public string Notes { get; set; }
        public int TenantId { get; set; }
    }
}
