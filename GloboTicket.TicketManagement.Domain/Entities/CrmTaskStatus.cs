﻿using ERPCubes.Domain.Common;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Domain.Entities
{
    public class CrmTaskStatus:AuditableEntity
    {
        [Key]
        public int StatusId { get; set; }
        public string StatusTitle { get; set; } = String.Empty;
    }
}
