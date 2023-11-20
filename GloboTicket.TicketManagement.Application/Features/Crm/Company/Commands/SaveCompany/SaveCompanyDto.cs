using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Company.Commands.SaveCompany
{
    public class SaveCompanyDto
    {
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
        public int? IndustryId { get; set; }
        public string? IndustryTitle { get; set; } = string.Empty;
        //public DateTime? CreatedDate { get; set; }
    }
}
