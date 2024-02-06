using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmFormFieldTypes: AuditableEntity
    {
        [Key]
        public int TypeId { get; set; }
        public string TypeName { get; set; }
        public string TypeLabel {  get; set; }
        public string Icon { get; set; }
    }
}
