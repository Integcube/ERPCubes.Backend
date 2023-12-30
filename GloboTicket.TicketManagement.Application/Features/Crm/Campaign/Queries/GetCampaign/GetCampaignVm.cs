using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Campaign.Queries.GetCampaign
{
    public class GetCampaignVm
    {
        public string CampaignId { get; set; } = string.Empty;
        public string AdAccountId { get; set; } = string.Empty;
        public string Title { get; set; } = string.Empty;
        public int ProductId { get; set; }
        //public string ProductName { get; set; } = string.Empty;
        public int SourceId { get; set; }
        //public string SourceTitle { get; set; } = string.Empty;
        public decimal Budget { get; set; }
    }
}
