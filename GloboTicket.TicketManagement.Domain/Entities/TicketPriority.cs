using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class TicketPriority
    {
        [Key]
        public int TicketPriorityId { get; set; }
        public string PriorityName { get; set; }
        public int IsDeleted { get; set; }
    }
}
