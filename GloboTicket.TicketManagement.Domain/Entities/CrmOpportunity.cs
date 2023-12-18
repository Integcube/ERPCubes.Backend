using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmOpportunity : AuditableEntity
    {
        [Key]
        public int OpportunityId { get; set; }
        public int TenantId { get; set; }
        public string OpportunityTitle { get; set; } = string.Empty;
        public int OpportunitySource { get; set; }
        public string? OpportunityDetail { get; set; } = string.Empty;
    }
}
