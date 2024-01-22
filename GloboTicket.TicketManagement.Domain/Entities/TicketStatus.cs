using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class TicketStatus
    {
        [Key]
        public int TicketStatusId { get; set; }
        public string StatusName { get; set; }
        public string Class { get; set; }
        public int IsDeleted { get; set; }
    }
}
