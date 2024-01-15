﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Lead.Commands.BulkSaveLead
{
    public class SaveBulkLeadDto
    {
        public int LeadId { get; set; }
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string? City { get; set; } = string.Empty;
        public int ProductId { get; set; }
        public string? Mobile { get; set; } = string.Empty;
        public string? Address { get; set; } = string.Empty;
        public string? Street { get; set; } = string.Empty;
        public string? Zip { get; set; } = string.Empty;
        public string? State { get; set; } = string.Empty;
        public string? Country { get; set; } = string.Empty;
        public int? SourceId { get; set; }
        public int? IndustryId { get; set; }
    }
}
