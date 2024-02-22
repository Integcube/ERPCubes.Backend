using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.SaveLead
{
    public class SaveLeadDto
    {
        public int LeadId { get; set; }
        public string FirstName { get; set; } 
        public string LastName { get; set; } 
        public string Email { get; set; }
        public int Status { get; set; }
        public string StatusTitle { get; set; } 
        public string LeadOwner { get; set; } 
        public string Mobile { get; set; } 
        public string Work { get; set; } 
        public string Address { get; set; } 
        public string Street { get; set; } 
        public string City { get; set; } 
        public string Zip { get; set; } 
        public string State { get; set; } 
        public string Country { get; set; } 
        public int SourceId { get; set; }
        public string SourceTitle { get; set; } 
        public int IndustryId { get; set; }
        public string IndustryTitle { get; set; } 
        public int ProductId { get; set; }
        public string ProductTitle { get; set; } 
        public string CampaignId { get; set; } 
        public DateTime CreatedDate { get; set; }
        public string Remarks { get; set; }
        
    }
}
