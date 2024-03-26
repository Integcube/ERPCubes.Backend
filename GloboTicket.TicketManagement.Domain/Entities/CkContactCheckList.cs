using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CkContactCheckList:AuditableEntity
    {
        [Key]
        public int CCLId { get; set; }
        public int TenantId { get; set; }
        public int? CLId { get; set; }
        public int StatusId { get; set; }
        public int ContactTypeId { get; set; }

    }
}
