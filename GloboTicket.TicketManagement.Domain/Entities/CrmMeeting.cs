using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmMeeting: AuditableEntity
    {
        [Key]
        public int MeetingId { get; set; }
        public string Subject { get; set; }=String.Empty;
        public string Note {  get; set; }= String.Empty;
        public int Id { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public int TenantId { get; set; }
        public int ContactTypeId { get; set; }
        
    }
}
