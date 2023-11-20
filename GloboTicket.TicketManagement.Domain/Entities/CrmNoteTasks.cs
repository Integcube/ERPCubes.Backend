using ERPCubes.Domain.Common;
using System.ComponentModel.DataAnnotations;

namespace ERPCubes.Domain.Entities
{
    public class CrmNoteTasks:AuditableEntity
    {
        [Key]
        public int NoteTaskId { get; set; }
        public int NoteId { get; set; }
        public string Task { get; set; } = String.Empty;
        public int IsCompleted { get; set; }
        public int TenantId { get; set; }
    }
}
