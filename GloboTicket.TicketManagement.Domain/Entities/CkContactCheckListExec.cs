using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CkContactCheckListExec:AuditableEntity
    {
        [Key]
        public int ExecCCLId { get; set; }
        public int TenantId { get; set; }
        public int Status { get; set; }
        public int ContactId { get; set; }
        public int ContactTypeId { get; set; }
        public int CPId { get; set; }
        public string CompletedBy { get; set; }
        public DateTime? CompletedOn { get; set; }
        
    }
}
