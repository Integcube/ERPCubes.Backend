using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Campaign.Commands.RestoreCampaign
{
    public class RestoreCampaignCommand : IRequest
    {
        public string CampaignId { get; set; } = string.Empty;

    }
}
