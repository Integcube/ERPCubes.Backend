using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class TicketType
    {
        [Key]
        public int TicketTypeId { get; set; }
        public string TypeName { get; set; }
        public int IsDeleted { get; set; }
    }
}
