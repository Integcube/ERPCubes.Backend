using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmProduct : AuditableEntity
    {
        [Key]
        public int ProductId { get; set; }
        public string ProductName { get; set; }=String.Empty;
        public string Description { get; set; } = String.Empty;
        public decimal Price { get; set; }
        public int ProjectId {  get; set; }
        public int TenantId { get; set; }
    }
}
