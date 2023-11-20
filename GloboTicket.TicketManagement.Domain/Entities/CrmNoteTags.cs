using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmNoteTags:AuditableEntity
    {
        [Key]
        public int NoteTagsId { get; set; }
        public int NoteId { get; set; }
        public int TagId { get; set; }
        public int TenantId { get; set; }
    }
}
