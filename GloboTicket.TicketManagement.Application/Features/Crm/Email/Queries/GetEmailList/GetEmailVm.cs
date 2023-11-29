using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Email.Queries.GetEmailList
{
    public class GetEmailVm
    {
        public int EmailId { get; set; }
        public string Subject { get; set; } = String.Empty;
        public string Description { get; set; } = String.Empty;
        public string Reply { get; set; } = String.Empty;
        public string CreatedBy { get; set; } = string.Empty;
        public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
    }
}
