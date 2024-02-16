using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmCampaign : AuditableEntity
    {
        [Key]
        public string CampaignId { get; set; } = string.Empty;
        public string AdAccountId { get; set; } = string.Empty;
        public string Title {  get; set; }= string.Empty;
        public int ProductId { get; set; }
        public int SourceId { get; set; }
        public decimal Budget { get; set; }
        public int TenantId { get; set; }
        public string DeletedBy { get; set; }
        public DateTime? DeletedDate { get; set; }
    }
}
