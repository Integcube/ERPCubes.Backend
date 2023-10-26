using ERPCubes.Domain.Common;
using System.ComponentModel.DataAnnotations;

namespace ERPCubes.Domain.Entities
{
    public class CrmCompany : AuditableEntity
    {
        [Key]
        public int CompanyId { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Website { get; set; } = string.Empty;
        public string CompanyOwner { get; set; } = string.Empty;
        public string? Mobile { get; set; } = string.Empty;
        public string? Work { get; set; } = string.Empty;
        public string? BillingAddress { get; set; } = string.Empty;
        public string? BillingStreet { get; set; } = string.Empty;
        public string? BillingCity { get; set; } = string.Empty;
        public string? BillingZip { get; set; } = string.Empty;
        public string? BillingState { get; set; } = string.Empty;
        public string? BillingCountry { get; set; } = string.Empty;
        public string? DeliveryAddress { get; set; } = string.Empty;
        public string? DeliveryStreet { get; set; } = string.Empty;
        public string? DeliveryCity { get; set; } = string.Empty;
        public string? DeliveryZip { get; set; } = string.Empty;
        public string? DeliveryState { get; set; } = string.Empty;
        public string? DeliveryCountry { get; set; } = string.Empty;
        public int IndustryId { get; set; }
        public int TenantId { get; set; }
    }
}
