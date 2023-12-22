﻿using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmUserActivityLog : AuditableEntity
    {
        [Key]
        public int ActivityId { get; set; }
        public string UserId { get; set; } = string.Empty;
        public int ActivityType { get; set; }
        public int ActivityStatus { get; set; }
        public string Detail { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public int Id { get; set; }
        public int IsLead { get; set; }
        public int IsCompany { get; set; }
        public int IsOpportunity { get; set; }
    }
}
