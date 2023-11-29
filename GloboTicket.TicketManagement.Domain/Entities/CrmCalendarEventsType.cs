using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmCalendarEventsType
    {
        [Key]
        public int TypeId { get; set; }
        public string TypeTitle { get; set; }=String.Empty;
        public int IsDeleted { get; set; }
    }
}
