﻿using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.UserActivity.Queries.GetUserActivity
{
    public class GetUserActivityQuery : IRequest<List<GetUserActivityVm>>
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = string.Empty;
        public int LeadId { get; set; } 
        public int CompanyId { get; set; }
        public int OpportunityId { get; set; }
        public int Count { get; set; } 
    }
}
