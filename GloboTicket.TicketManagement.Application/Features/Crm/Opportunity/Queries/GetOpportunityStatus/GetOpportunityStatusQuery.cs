﻿using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadStatus;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Opportunity.Queries.GetOpportunityStatus
{
    public class GetOpportunityStatusQuery : IRequest<List<GetOpportunityStatusVm>>
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = string.Empty;

    }
}
