using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetDeletedLeads
{
    public class GetDeletedLeadsVm
    {
        public int LeadId { get; set; }
        public string Name { get; set; } = string.Empty;
        public int Status {  get; set; }
        public string StatusTitle { get; set; } = string.Empty;
        public string LeadOwner { get; set; } = string.Empty;
        public string LeadOwnerName { get; set; } = string.Empty;
        public int ProductId { get; set; }
        public string ProductTitle { get; set; } = string.Empty;
        public string CampaignId { get; set; } = string.Empty;
        public string CampaignTitle { get; set; } = string.Empty;
        public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
    }
}
