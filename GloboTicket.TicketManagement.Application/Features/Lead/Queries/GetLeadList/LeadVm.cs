using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Lead.Queries.GetLeadList
{
    public class LeadVm
    {
        public int LeadId { get; set; }
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public int LeadStatus { get; set; }
        public int SalesOwner { get; set; }
        public int AssignedTo { get; set; }
        public string Mobile { get; set; } = string.Empty;
        public string Work { get; set; } = string.Empty;
        public string Address { get; set; } = string.Empty;
        public string Street { get; set; } = string.Empty;
        public string City { get; set; } = string.Empty;
        public string ZIP { get; set; } = string.Empty;
        public string State { get; set; } = string.Empty;
        public string Country { get; set; } = string.Empty;
        public int LeadSourceId { get; set; }
        public int LeadIndustryId { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
