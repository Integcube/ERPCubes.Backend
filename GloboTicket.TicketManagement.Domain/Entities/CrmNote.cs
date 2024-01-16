using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmNote: AuditableEntity
    {
        [Key]
        public int NoteId { get; set; }
        public string Content { get; set; } = String.Empty;
        public int Id { get; set; }
        public int ContactTypeId { get; set; }
        public int TenantId { get; set; }
        public string NoteTitle { get; set; } = string.Empty;
    }
}
