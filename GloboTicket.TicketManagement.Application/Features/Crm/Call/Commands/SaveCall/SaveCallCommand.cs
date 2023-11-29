﻿using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Call.Commands.SaveCall
{
    public class SaveCallCommand: IRequest
    {
        public int CallId { get; set; }
        public string Subject { get; set; } = String.Empty;
        public string Response { get; set; } = String.Empty;
        public string Id { get; set; } = string.Empty;
        public int IsCompany { get; set; }
        public int IsLead { get; set; }
        public int CompanyId { get; set; }
        public int LeadId { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public string CreatedBy { get; set; } = String.Empty;
        public DateTime? CreatedDate { get; set; }
        public int TenantId { get; set; }
    }
}
