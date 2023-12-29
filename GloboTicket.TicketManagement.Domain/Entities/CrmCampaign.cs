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
        public string Budget { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
