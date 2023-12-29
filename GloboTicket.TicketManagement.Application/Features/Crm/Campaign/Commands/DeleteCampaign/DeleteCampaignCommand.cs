using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Campaign.Commands.DeleteCampaign
{
    public class DeleteCampaignCommand:IRequest
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public string CampaignId { get; set; } = string.Empty;
    }
}
