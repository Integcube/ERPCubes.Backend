using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmUserActivityType
    {
        [Key]
        public int ActivityTypeId { get; set; }
        public string ActivityTypeTitle { get; set; } = string.Empty;
        public string Icon { get; set; } = string.Empty;
        public int IsDeleted { get; set; }
    }
    
}
