using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetStatusWiseLeads
{
    public class GetStatusWiseLeadsDto
    {
        public int LeadId { get; set; }
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public int Status { get; set; }
        public string LeadOwner { get; set; } = String.Empty;
        public string Mobile { get; set; } = string.Empty;
    }
}
