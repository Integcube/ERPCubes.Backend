using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmLead : AuditableEntity
    {
        [Key]
        public int LeadId { get; set; }
        public int TenantId { get; set; }
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public int Status { get; set; }
        public string LeadOwner { get; set; } = String.Empty;
        public string Mobile { get; set; } = string.Empty;
        public string Work { get; set; } = string.Empty;
        public string Address { get; set; } = string.Empty;
        public string Street { get; set; } = string.Empty;
        public string City { get; set; } = string.Empty;
        public string Zip { get; set; } = string.Empty;
        public string State { get; set; } = string.Empty;
        public string Country { get; set; } = string.Empty;
        public int SourceId { get; set; }
        public int IndustryId { get; set; }
        public int ProductId { get; set; }
        public string CampaignId { get; set; } = string.Empty;
        public string DeletedBy { get; set; }
        public DateTime? DeletedDate { get; set; }
    }
}
