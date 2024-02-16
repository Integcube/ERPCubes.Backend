using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Campaign.Commands.RestoreBulkCampiagn
{
    public class RestoreBulkCampaignCommand : IRequest
    {
        public List<string> CampaignId { get; set; }

    }
}
