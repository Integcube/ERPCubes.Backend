﻿using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ERPCubes.Application.Features.Crm.Email.Queries.GetEmailList
{
    public class GetEmailListQuery : IRequest<List<GetEmailVm>>
    {
        public string Id { get; set; } = string.Empty;
        public int TenantId { get; set; }
        public int ContactTypeId { get; set; }
        public int ContactId { get; set; }


    }
}
