using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CkUserCheckPointExec:AuditableEntity
    {
        [Key]
        public int CPExecId { get; set; }
        public int TenantId { get; set; }
        public int CPId { get; set; }
        public int Status { get; set; }
        public int ExecId { get; set; }
        public string UserId { get; set; }
    }
}
