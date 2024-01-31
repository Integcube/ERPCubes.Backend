using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class DocumentLibrary : AuditableEntity
    {
        [Key]
        public int FileId { get; set; }
        public string FileName { get; set; }
        public string Description { get; set; }
        public string Type { get; set; }
        public string Path { get; set; }
        public int ParentId { get; set; }
        public int Id { get; set; }
        public int TenantId { get; set; }

        public int ContactTypeId { get; set; }

    }
}
