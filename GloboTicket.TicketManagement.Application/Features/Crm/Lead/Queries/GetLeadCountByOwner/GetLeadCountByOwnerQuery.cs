﻿using ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadOwnerWiseReport;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Queries.GetLeadCountByOwner
{
    public class GetLeadCountByOwnerQuery : IRequest<List<GetLeadCountByOwnerVm>>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
    }
}

