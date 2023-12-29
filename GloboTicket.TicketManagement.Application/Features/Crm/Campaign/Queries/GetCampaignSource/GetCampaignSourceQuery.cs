using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Campaign.Queries.GetCampaignSource
{
    public class GetCampaignSourceQuery: IRequest<List<GetCampaignSourceVm>>
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = string.Empty;
    }
}
