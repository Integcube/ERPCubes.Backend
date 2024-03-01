using ERPCubes.Application.Features.Crm.Campaign.Commands.SaveBulkCampaign;
using ERPCubes.Application.Features.Crm.Lead.Commands.BulkSaveLead;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Campaign.Commands.SaveCampaign
{
    public class SaveBulkCampaignCommand : IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = String.Empty;
        public List<SaveBulkCampaignDto> Campaign { get; set; } = new List<SaveBulkCampaignDto>();
    }
}
