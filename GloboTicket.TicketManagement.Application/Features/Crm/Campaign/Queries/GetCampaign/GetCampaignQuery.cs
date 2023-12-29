﻿using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Campaign.Queries.GetCampaign
{
    public class GetCampaignQuery: IRequest<List<GetCampaignVm>>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}
