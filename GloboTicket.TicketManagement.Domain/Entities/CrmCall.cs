using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmCall : AuditableEntity
    {
        [Key]
        public int CallId { get; set; }
        public string Subject { get; set; } = String.Empty;
        public string Response { get; set; }
        public int Id { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public int TenantId { get; set; }
        public int ReasonId { get; set; }
        public int TaskId { get; set; }
        public int ContactTypeId { get; set; }
        public DateTime CallDate { get; set; }
        

    }
}
