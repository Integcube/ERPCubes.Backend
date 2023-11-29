﻿using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.CustomLists.Commands.SaveCustomList
{
    public class SaveCustomListCommand:IRequest
    {
        public int TenantId { get; set; }
        public string Id { get; set; } = String.Empty;
        public int ListId { get; set; }
        public string ListTitle { get; set; } = String.Empty;
        public int IsPublic { get; set; }
        public string Type { get; set; }
        public string Filter { get; set; } = String.Empty;
    }
}
