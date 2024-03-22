using ERPCubes.Domain.Common;
using System.ComponentModel.DataAnnotations;

namespace ERPCubes.Domain.Entities
{
    public class CkUserCheckPoint:AuditableEntity
    {
        [Key]
        public int UCPId { get; set; }
        public int TenantId { get; set; }
        public string CPId { get; set; }
        public string AssignTo { get; set; }
        public DateTime DueDate { get; set; }
        public int ExecId { get; set; }
        public int CLId { get; set; }

    }
}
