using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    [Table("CKExecCheckList")]
    public class CKExecCheckList: AuditableEntity
    {
        [Key]
        public int ExecId { get; set; }
        public int CLId { get; set; }
        public string Remarks { get; set; }
        public int TenantId { get; set; }
        public string Code { get; set; }
        public string Referenceno { get; set; }
        
    }
}
