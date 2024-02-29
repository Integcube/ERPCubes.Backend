﻿using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.DeleteBulkLeads
{
    public class DeleteBulkLeadsCommand : IRequest
    {
        public string Id { get; set; }
        public int TenantId { get; set; }
        
        public List<LeadIdsvm> Leads { get; set;}
    }


}