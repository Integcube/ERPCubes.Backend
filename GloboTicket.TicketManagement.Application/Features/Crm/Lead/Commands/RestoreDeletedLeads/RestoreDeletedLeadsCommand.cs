﻿using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.RestoreDeletedLeads
{
    public class RestoreDeletedLeadsCommand:IRequest
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public List<RestoreDeletedLeadsDto> deletedleads {  get; set; } = new List<RestoreDeletedLeadsDto>();
    }
}
