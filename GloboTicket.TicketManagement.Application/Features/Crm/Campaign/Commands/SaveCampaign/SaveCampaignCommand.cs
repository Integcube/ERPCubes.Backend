using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Campaign.Commands.SaveCampaign
{
    public class SaveCampaignCommand: IRequest
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public string CampaignId { get; set; } = string.Empty;
        public string AdAccountId { get; set; } = string.Empty;
        public string Title { get; set; } = string.Empty;
        public int ProductId { get; set; }
        public int SourceId { get; set; }
        public decimal Budget { get; set; }
        
    }
}
