﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.AdAccount.Commands.BulkSaveAdAccount
{
    public class SaveBulkAdAccountDto
    {
        public string AccountId { get; set; } = string.Empty;
        public string Title { get; set; } = string.Empty;
        public bool IsSelected { get; set; }
        public string SocialId { get; set; } = string.Empty;
        public string Provider { get; set; } = string.Empty;
    }
}
